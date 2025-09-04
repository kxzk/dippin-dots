[[ ! -o interactive ]] && return
# source aliases (zsh can use bash aliases)
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_keys ]] && source ~/.bash_keys

setopt PROMPT_SUBST
PROMPT='%F{green}rat@trashcan%f:%F{blue}%2~%f$ '

# my local binaries
export PATH="$HOME/.local/bin:$PATH"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
# rust (prepend after homebrew to take precedence)
export PATH="$HOME/.cargo/bin:$PATH"


. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

eval "$(zoxide init zsh)"
