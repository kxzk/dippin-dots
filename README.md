```text

██████╗ ██╗██████╗ ██████╗ ██╗███╗   ██╗    ██████╗  ██████╗ ████████╗███████╗
██╔══██╗██║██╔══██╗██╔══██╗██║████╗  ██║    ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
██║  ██║██║██████╔╝██████╔╝██║██╔██╗ ██║    ██║  ██║██║   ██║   ██║   ███████╗
██║  ██║██║██╔═══╝ ██╔═══╝ ██║██║╚██╗██║    ██║  ██║██║   ██║   ██║   ╚════██║
██████╔╝██║██║     ██║     ██║██║ ╚████║    ██████╔╝╚██████╔╝   ██║   ███████║
╚═════╝ ╚═╝╚═╝     ╚═╝     ╚═╝╚═╝  ╚═══╝    ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝
                                                                              
```

* Install homebrew apps
```bash
brew bundle
```

* Make fish default shell
```bash
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

* Add homebrew to fish path
```bash
fish_add_path /opt/homebrew/bin
```

* Stow commands
```bash
stow package

# simulate running
stow -nv package

# update -> restow
stow -Rv package
```

* [Install DuckDB CLI](https://duckdb.org/docs/installation/)

* Alias snowsql
```bash
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql
```
