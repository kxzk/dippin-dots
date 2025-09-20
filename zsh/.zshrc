[[ ! -o interactive ]] && return
# source aliases (zsh can use bash aliases)
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_keys ]] && source ~/.bash_keys

setopt PROMPT_SUBST
PROMPT='%F{green}boy@metal%f:%F{blue}%2~%f$ '

# my local binaries
export PATH="$HOME/.local/bin:$PATH"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# npm
export PATH="$HOME/.npm-global/bin:$PATH"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
# rust (prepend after homebrew to take precedence)
export PATH="$HOME/.cargo/bin:$PATH"

eval "$(rbenv init -)"

. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

eval "$(zoxide init zsh)"
