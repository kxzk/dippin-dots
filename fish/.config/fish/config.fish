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
alias pipi="cd ~/dippin-dots/ && pip3 install -r requirements.txt"
alias pipd="pip3 freeze | xargs pip3 uninstall -y"
alias pipu="pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U"

# util
alias g="git"
alias gp="git pull"
alias vim="nvim"
alias vi="nvim"
alias ib="issue_branch"
alias grep="grep --color=auto"
alias checkports="lsof -i -n -P | grep TCP"

# git
alias prrev="gh search prs --review-requested=@me --state=open"
alias prme="gh search prs --sort=updated --author=@me --state=open"

# exa (ls)
alias ls="exa"
alias tree="exa -lxT --no-permissions --no-time --no-user --no-filesize"
alias treesize="exa -lxT --no-permissions --no-time --no-user"
alias modelsize="exa -lxR --no-permissions --no-time --no-user --sort filesize --ignore-glob='*.yml|*.md' --reverse | awk '/^[1-9]/' | sort -hr"

# jira
alias jli="jira issue list -a$(jira me) -s~Done"

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
alias ghme="open https://github.com/kadekillary"
alias al="cd analytics"

# zoxide
zoxide init fish | source
alias cd="z"
