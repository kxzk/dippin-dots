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

k8s_prompt() {
    local ctx=$(kubectl config current-context 2>/dev/null | sed 's/teleport-//')
    local ns=$(kubens -c 2>/dev/null)
    if [[ -n $ctx ]]; then
        [[ -n $ns ]] && echo " %F{yellow}⟨k8s|$ctx:$ns%⟩f" || echo " %F{yellow}⟨k8s|$ctx⟩%f"
    fi
}

PROMPT='%F{green}boy@metal%f 𝝺 $(dir_prompt)$(k8s_prompt)$(git_prompt) '

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

# eval "$(rbenv init -)"

. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

eval "$(zoxide init zsh)"

# bun completions
[ -s "/Users/kade.killary/.bun/_bun" ] && source "/Users/kade.killary/.bun/_bun"

# use homebrew ruby by default
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"

# qlty completions
[ -s "/opt/homebrew/share/zsh/site-functions/_qlty" ] && source "/opt/homebrew/share/zsh/site-functions/_qlty"

# qlty
export QLTY_INSTALL="$HOME/.qlty"
export PATH="$QLTY_INSTALL/bin:$PATH"
