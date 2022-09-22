# -l -> local
# -g -> global
# -U -> universal
# -x -> export
# ln -sf path/og/ path/copy

# remove start up prompt
set -U fish_greeting

# navigation
alias ..="cd .."
alias ...="cd ../.."

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
alias vc="nvim ~/.config/nvim/init.lua"
alias tc="nvim ~/.tmux.conf"
alias tk="tmux kill-server"
alias todo="nvim ~/main.todo"
alias ip="curl ipecho.net/plain ; echo"
alias sshconfig="nvim ~/.ssh/config"
alias top="top -o cpu"
alias clean="rm -rf ~/.Trash/*; rm -rf ~/Downloads/*"
alias weather="curl wttr.in"
alias date="date '+%B %e, %Y'"
