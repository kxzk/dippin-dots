# exit early if non-interactive (scripts, scp, etc don't need prompt config)
[[ ! -o interactive ]] && return

# homebrew setup - default to apple silicon path, add completions to fpath
: ${HOMEBREW_PREFIX:=/opt/homebrew}
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit && compinit

# source aliases (zsh can use bash aliases)
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_keys ]] && source ~/.bash_keys

# enable variable expansion in prompt string
setopt PROMPT_SUBST

# get current git branch name, suppress errors for non-git dirs
git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# build git portion of prompt: branch name + dirty indicator
git_prompt() {
    local branch=$(git_branch)
    if [[ -n $branch ]]; then
        local dirty=""
        # diff-index is faster than status, returns non-zero if working tree differs from HEAD
        git diff-index --quiet HEAD 2>/dev/null || dirty=" %F{8}✱%f"
        echo " %F{magenta}❨$branch❩%f$dirty"
    fi
}

# show ~ at home, otherwise last 2 path components for context without clutter
dir_prompt() {
    if [[ "$PWD" == "$HOME" ]]; then
        echo "%F{red}~%f"
    else
        echo "%F{red}%2~%f"
    fi
}

# kubernetes context/namespace display with caching to avoid slow kubectl calls
k8s_prompt() {
    # only re-query kubectl if kubeconfig changed (hash mismatch)
    [[ -z $KUBECONFIG_HASH || $KUBECONFIG_HASH != $(md5 -q ~/.kube/config 2>/dev/null) ]] && {
        KUBECONFIG_HASH=$(md5 -q ~/.kube/config 2>/dev/null)
        # strip teleport- prefix for cleaner display
        K8S_CTX=$(kubectl config current-context 2>/dev/null | sed 's/teleport-//')
        K8S_NS=$(kubens -c 2>/dev/null)
    }
    [[ -n $K8S_CTX ]] && echo " %F{yellow}⟨k8s|$K8S_CTX${K8S_NS:+:$K8S_NS}⟩%f"
}

# precmd runs before each prompt - cache expensive operations here
precmd() {
    _dir=$(dir_prompt)
    _k8s=$(k8s_prompt)
    _git=$(git_prompt)
}

# final prompt assembly: user@host lambda dir k8s git
PROMPT='%F{green}boy@metal%f 𝝺 ${_dir}${_k8s}${_git} '

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
