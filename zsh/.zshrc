[[ ! -o interactive ]] && return
# source aliases (zsh can use bash aliases)
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_keys ]] && source ~/.bash_keys

setopt PROMPT_SUBST

git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
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
    [[ -z $KUBECONFIG_HASH || $KUBECONFIG_HASH != $(md5 -q ~/.kube/config 2>/dev/null) ]] && {
        KUBECONFIG_HASH=$(md5 -q ~/.kube/config 2>/dev/null)
        K8S_CTX=$(kubectl config current-context 2>/dev/null | sed 's/teleport-//')
        K8S_NS=$(kubens -c 2>/dev/null)
    }
    [[ -n $K8S_CTX ]] && echo " %F{yellow}⟨k8s|$K8S_CTX${K8S_NS:+:$K8S_NS}⟩%f"
}

precmd() {
    _dir=$(dir_prompt)
    _k8s=$(k8s_prompt)
    _git=$(git_prompt)
}
PROMPT='%F{green}boy@metal%f 𝝺 ${_dir}${_k8s}${_git} '

export BUN_INSTALL="$HOME/.bun"
export QLTY_INSTALL="$HOME/.qlty"

typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "/opt/homebrew/opt/ruby/bin"
    "/opt/homebrew/lib/ruby/gems/3.4.0/bin"
    "/opt/homebrew/bin"
    "$BUN_INSTALL/bin"
    "$HOME/.npm-global/bin"
    "$QLTY_INSTALL/bin"
    "$HOME/go/bin"
    "/usr/local/zig"
    $path
)

# eval "$(rbenv init -)"

[[ -f "$HOME/.atuin/bin/env" ]] && . "$HOME/.atuin/bin/env"
(( $+commands[atuin] )) && eval "$(atuin init zsh)"

(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# lazy-load completions
compdef _bun bun 2>/dev/null || {
    _bun() { source "$HOME/.bun/_bun" && _bun "$@" }
}
compdef _qlty qlty 2>/dev/null || {
    _qlty() { [[ -s "/opt/homebrew/share/zsh/site-functions/_qlty" ]] && source "/opt/homebrew/share/zsh/site-functions/_qlty" && _qlty "$@" }
}
