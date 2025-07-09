function gwk
    if test (count $argv) -ne 1
        return 1
    end
    set -l branch $argv[1]

    set -l repo_root (git rev-parse --show-toplevel)
    # cd trick guarantees an absolute, non-empty parent dir
    set -l parent_dir (cd $repo_root/..; pwd)
    set -l target_dir "$parent_dir/$branch"

    if not test -w $parent_dir
        echo "gwk: parent directory $parent_dir is not writable"
        return 1
    end

    set -l here $PWD
    cd $repo_root

    # try to add worktree tracking origin branch
    if not git worktree add -B $branch $target_dir origin/$branch >/dev/null 2>&1
        # if that fails, create a new branch
        if not git worktree add -b $branch $target_dir >/dev/null 2>&1
            echo "gwk: unable to add worktree for '$branch'"
            cd $here
            return 1
        end
    end

    cd $here
    cd $target_dir
    
    # Clean output in ASCII box
    set -l msg "Switched to worktree: $branch"
    set -l len (string length "$msg")
    set -l border (string repeat -n (math $len + 4) "─")
    
    echo "┌$border┐"
    echo "│  $msg  │"
    echo "└$border┘"
    
    commandline -f repaint
end

