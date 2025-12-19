<h3 align="center">🍦 dippin dots</h3>

<p align="center">
  <em>dotfiles managed with <a href="https://www.gnu.org/software/stow/">GNU Stow</a></em>
</p>

<br>

### Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/kxzk/dippin-dots/main/bootstrap.sh | bash
```

<br>

### Stow Commands

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

### Post-Install

#### GitHub CLI
```bash
gh auth login
gh config set editor nvim
gh config set pager delta
```

#### Atuin (shell history)
```bash
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
atuin register -u <USERNAME> -e <EMAIL>
atuin import auto
atuin sync
```

#### Claude Code
```bash
brew install --cask claude-code
```

#### Bun
```bash
curl -fsSL https://bun.sh/install | bash
```

#### DuckDB
```bash
curl https://install.duckdb.org | sh
```

#### Go Air (hot reload)
```bash
go install github.com/air-verse/air@latest
```

<br>

<p align="center">
  <sub>macOS • zsh • neovim • ghostty</sub>
</p>
