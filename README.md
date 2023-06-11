![colors](https://github.com/kxzk/dippin-dots/assets/25046261/305c7cbe-5735-4222-adb3-8511dd4c238d)

<br>

* Get started
> update `/Users/<UPDATE-NAME>/.zprofile` in [bootstrap.sh](https://github.com/kxzk/dippin-dots/blob/main/bootstrap.sh)

```bash
curl https://raw.githubusercontent.com/kxzk/dippin-dots/main/bootstrap.sh > bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh
```

<br>

* Stow commands
```bash
cd dippin-dots
stow -Rv fish
restow_dirs

# simulate running
stow -nv package
```

<br>

* Neovim - need to update to [lazy.nvim](https://github.com/folke/lazy.nvim)

```text
* Comment out init.lua
* Comment out mason require in plugins.lua
* Open & run :PackerSync
```

<br>
<br>

---

<br>
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

* Set github cli to use neovim
```
gh config set editor nvim
```

<br>
