# navigation
alias ..="z .."
alias ...="z ../.."

# python
alias ativ="source .venv/bin/activate.fish"
alias dativ="deactivate"
alias pipi="cd ~/dippin-dots/ && pip3 install -r requirements.txt --break-system-packages"

# ignores
alias ignorepy="curl https://www.toptal.com/developers/gitignore/api/python,macos,data,jupyternotebooks > .gitignore"
alias ignorego="curl https://www.toptal.com/developers/gitignore/api/go,macos > .gitignore"
alias ignorerust="curl https://www.toptal.com/developers/gitignore/api/rust,rust-analyzer,macos > .gitignore"
alias ignoreruby="curl https://www.toptal.com/developers/gitignore/api/ruby,macos > .gitignore"

# util
alias checkports="lsof -i -n -P | grep TCP"
alias ip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -v 127.0.0.1"
alias fire="caffeinate -dimus cacafire"
alias wake="caffeinate -dims"
alias ccost="bunx ccusage"

# shortcuts
alias cd="z"
alias g="git"
alias vim="nvim"
alias vi="nvim"
alias grep="grep --color=auto"
alias weather="curl wttr.in"
alias today="date '+%B %e, %Y'"
alias dots="cd dippin-dots"
alias h="cd desktop"

mk() { mkdir -p "$1" && cd "$1"; }

# eza (ls)
alias ls="eza --icons"
alias lst="eza -T --icons"
alias tree="eza -lxT --no-permissions --no-time --no-user --no-filesize --icons"
alias treesize="eza -lxT --no-permissions --no-time --no-user"

# github
alias prrev="gh search prs --review-requested=@me --state=open"
alias prme="gh search prs --sort=updated --author=@me --state=open"

# claude code
alias cldp="claude --dangerously-skip-permissions --disallowedTools NotebookEdit,NotebookWrite"
alias cl="claude --disallowedTools NotebookEdit,NotebookWrite"

# codex
alias cx="codex --model 'gpt-5-codex' --yolo -c model_reasoning_summary_format=experimental"

# sp
alias sp='/Users/kade.killary/dev/docker-dev/bin/sp'
