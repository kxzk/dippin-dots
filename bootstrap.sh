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
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	fi

	# Add Homebrew to shell environment
	if [[ "${SHELL}" == *"zsh"* ]]; then
		SHELL_PROFILE="${HOME}/.zprofile"
	else
		SHELL_PROFILE="${HOME}/.bash_profile"
	fi

	# Add brew shellenv if not already present
	if ! grep -q 'brew shellenv' "${SHELL_PROFILE}" 2>/dev/null; then
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${SHELL_PROFILE}"
	fi

	# Source the profile for current session
	source "${SHELL_PROFILE}"

	# Install Ghostty if not already installed
	if ! brew list --cask ghostty &> /dev/null; then
		brew install --cask ghostty
	fi

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

	# install and configure fish shell
	if ! brew list fish &> /dev/null; then
		brew install fish
	fi

	# add fish to allowed shells if not already present
	if ! grep -q "/opt/homebrew/bin/fish" /etc/shells; then
		echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
	fi

	# change default shell to fish if not already set
	if [[ "${SHELL}" != "/opt/homebrew/bin/fish" ]]; then
		echo "Changing default shell to fish..."
		chsh -s /opt/homebrew/bin/fish
	fi

	# configure fish path - run this in fish context
	/opt/homebrew/bin/fish -c 'fish_add_path /opt/homebrew/bin'

	# stow dotfiles if directories exist
	if [[ -d "fish" ]] && command -v stow &> /dev/null; then
		echo "Stowing fish configuration..."
		stow fish
	fi
}

bootstrap
