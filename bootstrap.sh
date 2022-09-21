#!/usr/bin/env bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

bootstrap() {
	xcode-select --install
	sudo xcodebuild -license accept

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/kade/.zprofile
	source .zprofile

	brew install stow
}

bootstrap
