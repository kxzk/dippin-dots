[[ ! -o interactive ]] && return
# source aliases (zsh can use bash aliases)
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_keys ]] && source ~/.bash_keys

setopt PROMPT_SUBST

git_branch() {
    git branch 2>/dev/null | sed -n 's/^\* //p'
}

git_prompt() {
    local branch=$(git_branch)
    if [[ -n $branch ]]; then
        local git_status=$(git status --porcelain 2>/dev/null)
        local dirty=""
        [[ -n $git_status ]] && dirty=" %F{8}✱%f"
        echo " %F{magenta}⦗$branch⦘%f$dirty"
    fi
}

dir_prompt() {
    if [[ "$PWD" == "$HOME" ]]; then
        echo "%F{blue}~%f"
    else
        echo "%F{blue}%2~%f"
    fi
}

PROMPT='%F{green}boy@metal%f 𝝺 $(dir_prompt)$(git_prompt) '

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

# bun completions
[ -s "/Users/kade.killary/.bun/_bun" ] && source "/Users/kade.killary/.bun/_bun"
