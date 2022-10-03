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

# shortcuts
alias snowsql="/Applications/SnowSQL.app/Contents/MacOS/snowsql"
alias D="~/duckdb"
alias tk="tmux kill-server"
alias ip="curl ipecho.net/plain ; echo"
alias sshconfig="nvim ~/.ssh/config"
alias top="top -o cpu"
alias weather="curl wttr.in"
alias date="date '+%B %e, %Y'"
alias dots="~/dippin-dots"

# pyenv
pyenv init - | source

# zoxide
zoxide init fish | source
alias cd="z"
