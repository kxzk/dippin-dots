#!/usr/bin/env bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

bootstrap() {
	# install xcode command line tools if not already installed
	if ! xcode-select -p &> /dev/null; then
		echo "Installing Xcode Command Line Tools..."
		xcode-select --install
		# wait for installation to complete
		until xcode-select -p &> /dev/null; do
			sleep 5
		done
	fi

	# accept xcode license if needed
	if ! sudo xcodebuild -license check &> /dev/null; then
		sudo xcodebuild -license accept
	fi

	# Install Homebrew if not already installed
	if ! command -v brew &> /dev/null; then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	# Add Homebrew to shell environment
	if [[ "${SHELL}" == *"zsh"* ]]; then
		SHELL_PROFILE="${HOME}/.zprofile"
	else
		SHELL_PROFILE="${HOME}/.bash_profile"
	fi

	# Add brew shellenv if not already present
	BREW_PATH="/opt/homebrew/bin/brew"
	[[ "$(uname -m)" == "x86_64" ]] && BREW_PATH="/usr/local/bin/brew"
	if ! grep -q 'brew shellenv' "${SHELL_PROFILE}" 2>/dev/null; then
		echo "eval \"\$(${BREW_PATH} shellenv)\"" >> "${SHELL_PROFILE}"
	fi

	# Source the profile for current session
	source "${SHELL_PROFILE}"

	# Install stow if not already installed
	if ! brew list stow &> /dev/null; then
		brew install stow
	fi

	# Run brew bundle if Brewfile exists
	if [[ -f "Brewfile" ]]; then
		brew bundle
	else
		echo "Warning: No Brewfile found in current directory"
	fi

	# stow dotfiles
	STOW_DIRS=(atuin codex cursor ghostty git hushlogin ipython irb nvim tmux zsh)
	for dir in "${STOW_DIRS[@]}"; do
		if [[ -d "${dir}" ]]; then
			echo "Stowing ${dir}..."
			stow "${dir}"
		fi
	done

	# stow bin to ~/.local/bin
	if [[ -d "bin" ]]; then
		mkdir -p "${HOME}/.local/bin"
		echo "Stowing bin..."
		stow -Rv bin -t "${HOME}/.local/bin"
	fi

	# stow claude to ~/.claude/
	if [[ -d "claude" ]]; then
		mkdir -p "${HOME}/.claude"
		echo "Stowing claude..."
		stow -Rv claude -t "${HOME}/.claude"
	fi
}

bootstrap
