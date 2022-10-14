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

# random
alias quote="daily-quote"

# python
alias pipd="pip3 freeze | xargs pip3 uninstall -y"
alias pipu="pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U"

# util
alias g="git"
alias ls="exa"
alias vim="nvim"
alias vi="nvim"
alias grep="grep --color=auto"
alias tree="exa -lxT --no-permissions --no-time --no-user --no-filesize"
alias treesize="exa -lxT --no-permissions --no-time --no-user"
alias modelsize="exa -lxR --no-permissions --no-time --no-user --sort filesize --ignore-glob='*.yml|*.md' --reverse | awk '/^[1-9]/' | sort -hr"
alias jli="jira issue list -a$(jira me)"
alias checkports="lsof -i -n -P | grep TCP"

# shortcuts
alias snowsql="/Applications/SnowSQL.app/Contents/MacOS/snowsql"
alias D="~/duckdb"
alias tk="tmux kill-server"
alias ip="curl ipecho.net/plain ; echo"
alias sshconfig="nvim ~/.ssh/config"
alias top="top -o cpu"
alias weather="curl wttr.in"
alias today="date '+%B %e, %Y'"
alias dots="~/dippin-dots"

# zoxide
zoxide init fish | source
alias cd="z"
