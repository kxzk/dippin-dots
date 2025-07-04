# -l -> local
# -g -> global
# -U -> universal
# -x -> export
# ln -sf path/og/ path/copy

# remove start up prompt
set -U fish_greeting

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
alias g="git"
alias vim="nvim"
alias vi="nvim"
# alias ib="issue_branch"
alias grep="grep --color=auto"
alias checkports="lsof -i -n -P | grep TCP"
alias license="curl https://gist.githubusercontent.com/kadekillary/dbc6007d5e8f7bd6b2a54270b192f547/raw/1ac0c8ac6b26a8471e14f6a627833f8d9e75f765/LICENSE > LICENSE"

# git
alias prrev="gh search prs --review-requested=@me --state=open"
alias prme="gh search prs --sort=updated --author=@me --state=open"

# change `gh` colo to make it easier to read on light terminal
# set -gx GLAMOUR_STYLE dracula

# eza (ls)
alias ls="eza --icons"
alias lst="eza -T --icons"
alias tree="eza -lxT --no-permissions --no-time --no-user --no-filesize --icons"
alias treesize="eza -lxT --no-permissions --no-time --no-user"
alias modelsize="eza -lxR --no-permissions --no-time --no-user --sort filesize --ignore-glob='*.yml|*.md' --reverse | awk '/^[1-9]/' | sort -hr"

# jira
# alias jli="jira issue list -a$(jira me) -s~Done"

# shortcuts
# alias snowsql="/Applications/SnowSQL.app/Contents/MacOS/snowsql"
alias D="duckdb"
alias ip="curl ipecho.net/plain ; echo"
alias sshconfig="nvim ~/.ssh/config"
alias top="top -o cpu"
alias weather="curl wttr.in"
alias today="date '+%B %e, %Y'"
alias dots="cd dippin-dots"
alias h="cd desktop"
alias claude="$HOME/.claude/local/claude"
alias cl="CLAUBBIT=1 CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 ENABLE_BACKGROUND_TASKS=1 $HOME/.claude/local/claude --dangerously-skip-permissions --disallowedTools NotebookEdit,NotebookWrite"
alias sp='/Users/kade.killary/dev/docker-dev/bin/sp'
# alias vd="vd --theme=ascii8"
alias fire="caffeinate -dimus cacafire"

set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH $PATH $HOME/go/bin

# atuin
set -gx ATUIN_NOBIND true
atuin init fish | source

# bind to ctrl-r in normal and insert mode, add any other bindings you want here too
bind \cr _atuin_search
bind -M insert \cr _atuin_search

# zoxide
zoxide init fish | source
alias cd="z"
