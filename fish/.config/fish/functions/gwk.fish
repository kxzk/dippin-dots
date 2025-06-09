function gwk
    if test (count $argv) -ne 1
        echo "Usage: gwk <branch-name>"
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
    if not git worktree add -B $branch $target_dir origin/$branch ^/dev/null
        # if that fails, create a new branch
        if not git worktree add -b $branch $target_dir
            echo "gwk: unable to add worktree for '$branch'"
            cd $here
            return 1
        end
    end
    
    cd $here
    cd $target_dir
    commandline -f repaint
end