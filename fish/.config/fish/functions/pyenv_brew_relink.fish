function pyenv_brew_relink
    rm -f contains 'brew' (ls $HOME/.pyenv/versions/)
    for p in $(brew --cellar)/python*
        for v in $p/*
            set -l py_brew_v (string split -r -m1 / $v)
            set -l PYBV $py_brew_v[-1]
            echo $PYBV
            ln -s -f $v $HOME/.pyenv/versions/$PYBV-brew
        end
    end
    pyenv rehash
end
