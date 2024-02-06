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
alias pipi="cd ~/dippin-dots/ && pip3 install -r requirements.txt"
alias pipd="pip3 freeze | xargs pip3 uninstall -y"
alias pipu="pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U"

# ignores
alias ignorepy="curl https://www.toptal.com/developers/gitignore/api/python,macos,data,jupyternotebooks > .gitignore"
alias ignorego="curl https://www.toptal.com/developers/gitignore/api/go,macos > .gitignore"

# go
alias air="/Users/edak/go/bin/air"
alias golines="/Users/edak/go/bin/golines"

# util
alias g="git"
alias gp="git pull"
alias gbl="git bl"
alias vim="nvim"
alias vi="nvim"
# alias ib="issue_branch"
alias grep="grep --color=auto"
alias checkports="lsof -i -n -P | grep TCP"
alias license="curl https://gist.githubusercontent.com/kadekillary/dbc6007d5e8f7bd6b2a54270b192f547/raw/1ac0c8ac6b26a8471e14f6a627833f8d9e75f765/LICENSE > LICENSE"

# git
alias prrev="gh search prs --review-requested=@me --state=open"
alias prme="gh search prs --sort=updated --author=@me --state=open"

# eza (ls)
alias ls="eza"
alias tree="eza -lxT --no-permissions --no-time --no-user --no-filesize"
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
alias D="cd desktop"

# pyenv
# pyenv init - | source
# zoxide
zoxide init fish | source
alias cd="z"
