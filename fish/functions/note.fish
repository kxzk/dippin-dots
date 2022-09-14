function note
    set -l notes_dir "$HOME/notes"
    switch $argv[1]
    case c
        cd $notes_dir
    case l
        ls $notes_dir
    end
end
