<h3 align="center">dippin dots</h3>

<br>
<br>

* get started
> update `/Users/<UPDATE-NAME>/.zprofile` in [bootstrap.sh](https://github.com/kxzk/dippin-dots/blob/main/bootstrap.sh)

```bash
curl https://raw.githubusercontent.com/kxzk/dippin-dots/main/bootstrap.sh > bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh
```

<br>

* stow commands

```bash
cd dippin-dots
stow -Rv fish
restow_dirs

# simulate running
stow -nv package
```

<br>

* login to github cli

```bash
gh auth login
```

<br>

* setup copilot for neovim

```
:Copilot setup
```

<br>

* install [air](https://github.com/cosmtrek/air) for go

```bash
curl -sSfL https://raw.githubusercontent.com/cosmtrek/air/master/install.sh | sh -s -- -b $(go env GOPATH)/bin
```

<br>
<br>

---

<br>
<br>

* alias snowsql

```bash
brew install --cask snowflake-snowsql
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql
```

<br>

* [pyenv](https://github.com/pyenv/pyenv) install

```fish
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

# add to config.fish
pyenv init - | source
```

<br>

* set github cli to use neovim

```
gh config set editor nvim
```

<br>
