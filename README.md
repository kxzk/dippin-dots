<h3 align="center">DIPPIN DOTS</h3>

<br>

* Install homebrew apps
```bash
brew bundle
```

<br>

* Make fish default shell
```bash
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

<br>

* Add homebrew to fish path
```fish
fish_add_path /opt/homebrew/bin
```

<br>

* Stow commands
```bash
stow package

# simulate running
stow -nv package

# update -> restow
stow -Rv package
```

<br>

* [Install DuckDB CLI](https://duckdb.org/docs/installation/)

<br>

* Alias snowsql
```bash
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql
```

<br>

* [Pyenv](https://github.com/pyenv/pyenv) install
```fish
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

# add to config.fish
pyenv init - | source
```

<br>

* Install Alacritty w/o Mac security snearing
```
brew install --cask alacritty --no-quarantine
```

<br>

* Set github cli to use neovim
```
gh config set editor nvim
```

<br>

* Disable Apple screenshot shadows

```bash
defaults write com.apple.screencapture disable-shadow -bool true
```
