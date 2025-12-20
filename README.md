<h3 align="center">🍦 dippin dots</h3>

<p align="center">
  <em>dotfiles managed with <a href="https://www.gnu.org/software/stow/">stow</a></em>
</p>

<br>

### quick start

```bash
curl -fsSL https://raw.githubusercontent.com/kxzk/dippin-dots/main/bootstrap.sh | bash
```

<br>

### stow commands

```bash
cd dippin-dots

stow <package>        # symlink a package
stow -D <package>     # unlink a package
stow -R <package>     # restow (unlink + link)
stow -nv <package>    # dry run (simulate)

# stow all packages
restow_dirs
```

<br>

### post-install

#### github cli
```bash
gh auth login
gh config set editor nvim
gh config set pager delta
```

#### atuin (shell history)
```bash
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
atuin register -u <USERNAME> -e <EMAIL>
atuin import auto
atuin sync
```

#### claude code
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

#### bun
```bash
curl -fsSL https://bun.sh/install | bash
```

#### duckdb
```bash
curl https://install.duckdb.org | sh
```

#### ghostty (terminal)
```bash
# download from https://ghostty.org/download
```

#### tableplus (database gui)
```bash
# download from https://tableplus.com/
```

#### dash (api docs)
```bash
# download from https://kapeli.com/dash
```

#### go air (hot reload)
```bash
go install github.com/air-verse/air@latest
```

<br>
