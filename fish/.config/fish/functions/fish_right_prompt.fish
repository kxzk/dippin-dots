function fish_right_prompt
    set -l last_status $status
    set -l git_info ""
    set -l git_symbols ""

    # Show exit status if non-zero
    if test $last_status -ne 0
        echo -n (set_color $fish_color_error 2>/dev/null; or set_color red)"✘ $last_status "(set_color normal)
    end

    # Early return if git isn't installed
    if not command -sq git
        return
    end

    # Fast check if inside git repo
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        return
    end

    # Cache the git directory
    set -l git_dir (git rev-parse --git-dir 2>/dev/null)

    # Branch info
    set -l branch ""
    set -l branch_color normal

    # Try to get branch name
    if set -l branch_name (git symbolic-ref --short HEAD 2>/dev/null)
        set branch $branch_name
        set branch_color brgreen
    else
        # Detached HEAD state - get SHA or tag
        set branch (git describe --contains --all HEAD 2>/dev/null)
        set branch_color brmagenta
    end

    # Get current git action (rebase/merge)
    if test -f "$git_dir/MERGE_HEAD"
        set -l git_action merge
        set git_info "$git_info"(set_color brred)" $git_action"
    else if test -d "$git_dir/rebase-merge"
        set -l git_action rebase
        set git_info "$git_info"(set_color brred)" $git_action"
    else if test -d "$git_dir/rebase-apply"
        set -l git_action rebase
        set git_info "$git_info"(set_color brred)" $git_action"
    else if test -f "$git_dir/CHERRY_PICK_HEAD"
        set -l git_action cherry-pick
        set git_info "$git_info"(set_color brred)" $git_action"
    else if test -f "$git_dir/REVERT_HEAD"
        set -l git_action revert
        set git_info "$git_info"(set_color brred)" $git_action"
    else if test -f "$git_dir/BISECT_LOG"
        set -l git_action bisect
        set git_info "$git_info"(set_color brred)" $git_action"
    end

    # Get upstream status (faster method)
    set -l ahead 0
    set -l behind 0
    if set -l upstream (git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
        git rev-list --left-right --count 'HEAD...@{upstream}' 2>/dev/null | read -l ahead behind
    end

    # Stash status (faster check)
    set -l stashed 0
    if test -f "$git_dir/refs/stash"
        set stashed 1
    else if test -r "$git_dir/commondir"
        read -l commondir <"$git_dir/commondir"
        if test -f "$commondir/refs/stash"
            set stashed 1
        end
    end

    # Get status using a more optimized approach
    set -l is_dirty 0
    set -l status_output (git status --porcelain 2>/dev/null)

    # Parse the status in a single pass
    set -l untracked 0
    set -l added 0
    set -l modified 0
    set -l renamed 0
    set -l deleted 0
    set -l unmerged 0

    # Process status with a single iteration
    for line in $status_output
        set -l xy (string sub -l 2 -- $line)
        set -l x (string sub -l 1 -- $xy)
        set -l y (string sub -s 2 -l 1 -- $xy)

        switch $xy
            case '\?\?'
                set untracked 1
            case 'A?' 'A ' 'M ' 'C '
                set added 1
            case '?M' ' M' MM
                set modified 1
            case '?D' ' D'
                set deleted 1
            case R?
                set renamed 1
            case DD AA U? ?U UU
                set unmerged 1
        end

        # Early exit on first dirty flag - for performance
        set is_dirty 1
    end

    # Build the symbol string
    if test $ahead -gt 0
        set git_symbols "$git_symbols"(set_color brmagenta)" ⇡$ahead"
    end
    if test $behind -gt 0
        set git_symbols "$git_symbols"(set_color brmagenta)" ⇣$behind"
    end
    if test $stashed -eq 1
        set git_symbols "$git_symbols"(set_color cyan)" ✭"
    end
    if test $added -eq 1
        set git_symbols "$git_symbols"(set_color green)" ✚"
    end
    if test $deleted -eq 1
        set git_symbols "$git_symbols"(set_color red)" ✖"
    end
    if test $modified -eq 1
        set git_symbols "$git_symbols"(set_color blue)" ✱"
    end
    if test $renamed -eq 1
        set git_symbols "$git_symbols"(set_color magenta)" ➜"
    end
    if test $unmerged -eq 1
        set git_symbols "$git_symbols"(set_color yellow)" ═"
    end
    if test $untracked -eq 1
        set git_symbols "$git_symbols"(set_color white)" ◼"
    end

    # Output branch and symbols
    if test -n "$branch"
        set_color $branch_color
        echo -n " $branch"
        echo -n $git_info
        echo -n $git_symbols
    end

    set_color normal
end
