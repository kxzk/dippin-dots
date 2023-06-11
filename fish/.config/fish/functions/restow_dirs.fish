function restow_dirs
    set -l packages alacritty fish git nvim tmux duckdb hushlogin
    for p in $packages
        stow -Rv $p
    end
end
