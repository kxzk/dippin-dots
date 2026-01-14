# exit early if non-interactive (scripts, scp, etc don't need prompt config)
[[ ! -o interactive ]] && return

# homebrew setup - default to apple silicon path, add completions to fpath
: ${HOMEBREW_PREFIX:=/opt/homebrew}
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit && compinit -C -d ~/.zcompdump

# source aliases (zsh can use bash aliases)
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_keys ]] && source ~/.bash_keys

# enable variable expansion in prompt string
setopt PROMPT_SUBST

git_prompt() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ -z $branch ]] && return
    local dirty="" branch_color="magenta"
    git diff-index --quiet HEAD 2>/dev/null || dirty=" %F{8}✱%f"
    if [[ $branch =~ ^feature/(ml-[0-9]{3,4}.*) ]]; then
        branch="linear/${match[1]}"
        branch_color="8"
    fi
    echo " %F{$branch_color}❨$branch❩%f$dirty"
}


k8s_prompt() {
    local hash=$(md5 -q ~/.kube/config 2>/dev/null)
    [[ -z $KUBECONFIG_HASH || $KUBECONFIG_HASH != $hash ]] && {
        KUBECONFIG_HASH=$hash
        K8S_CTX=${$(kubectl config current-context 2>/dev/null)#teleport-}
        K8S_NS=$(kubens -c 2>/dev/null)
    }
    [[ -n $K8S_CTX ]] && echo " %F{yellow}⟨k8s|$K8S_CTX${K8S_NS:+:$K8S_NS}⟩%f"
}

precmd() {
    _k8s=$(k8s_prompt)
    _git=$(git_prompt)
}

PROMPT='%F{green}boy@metal%f 𝝺 %F{blue}%2~%f${_k8s}${_git} '

# tool install directories for path construction
export BUN_INSTALL="$HOME/.bun"
export QLTY_INSTALL="$HOME/.qlty"

# typeset -U ensures unique entries (no duplicates in path)
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

# atuin: better shell history with sync/search
[[ -f "$HOME/.atuin/bin/env" ]] && . "$HOME/.atuin/bin/env"

# cache atuin init output - regenerate only when binary updates
# avoids ~50ms startup penalty from running init every shell
atuin_cache="$HOME/.zsh_atuin"
if [[ ! -f "$atuin_cache" || "$commands[atuin]" -nt "$atuin_cache" ]]; then
    atuin init zsh > "$atuin_cache"
fi
source "$atuin_cache"

# cache zoxide init output - same pattern as atuin
# zoxide: smarter cd that learns your frequent directories
zoxide_cache="$HOME/.zsh_zoxide"
if [[ ! -f "$zoxide_cache" || "$commands[zoxide]" -nt "$zoxide_cache" ]]; then
    zoxide init zsh > "$zoxide_cache"
fi
source "$zoxide_cache"

# bun completions
[ -s "/Users/kade.killary/.bun/_bun" ] && source "/Users/kade.killary/.bun/_bun"
