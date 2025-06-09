function mem --description 'simple agent memory system'
    set -q MEM_MASTER; or set -g MEM_MASTER $HOME/.config/agent-mem/agent.mem
    set -q MEM_FILE; or set -g MEM_FILE ./agent.mem
    function _usage
        printf '%s\n' '
    mem – manage agent task / note memory

  mem -a "<task text>"           add new task
  mem -n "<note text>"           add new note
  mem -l task | note | done          list entries by type
  mem -d <id >                    mark task <id > as done
  mem -r <id >                    remove note <id >
  mem -s <pattern >               search open tasks for text
  mem -g                         copy master file here
  mem -h                         show this help
'
    end

    function _next_id --argument prefix
        set -l max (grep "^$prefix:" $MEM_FILE 2>/dev/null \
                    | awk -F: '{print $2}' | sort -n | tail -1)
        test -z "$max"; and echo 1; or math $max + 1
    end

    function _safe_append --argument line
        if type -q flock
            flock -x "$MEM_FILE" -c "printf '%s\n' \"$line\" >> \"$MEM_FILE\""
        else
            printf '%s\n' "$line" >>"$MEM_FILE"
        end
    end

    argparse \
        (fish_opt -s a -l add=) \
        (fish_opt -s n -l note=) \
        (fish_opt -s l -l list=) \
        (fish_opt -s d -l done=) \
        (fish_opt -s r -l remove=) \
        (fish_opt -s s -l search=) \
        (fish_opt -s g -l get) \
        (fish_opt -s h -l help) -- $argv

    if set -q _flag_h
        _usage
        return 0
    end

    set -l IS_DARWIN (string match -r "darwin" (uname) >/dev/null; and echo 1)

    if set -q _flag_a
        set -l id (_next_id task)
        _safe_append "task:$id: $_flag_a"
        echo "added task $id"

    else if set -q _flag_n
        set -l id (_next_id note)
        _safe_append "note:$id: $_flag_n"
        echo "added note $id"

    else if set -q _flag_l
        grep "^$_flag_l:" $MEM_FILE || true

    else if set -q _flag_d
        if test -n "$IS_DARWIN"
            command sed -i '' -e "/^task:$_flag_d:/s/^task:/done:/" "$MEM_FILE"
        else
            command sed -i -e "/^task:$_flag_d:/s/^task:/done:/" "$MEM_FILE"
        end
        echo "task $_flag_d marked done"

    else if set -q _flag_r
        if test -n "$IS_DARWIN"
            command sed -i '' -e "/^note:$_flag_r:/d" "$MEM_FILE"
        else
            command sed -i -e "/^note:$_flag_r:/d" "$MEM_FILE"
        end
        echo "note $_flag_r removed"

    else if set -q _flag_s
        grep '^task:' $MEM_FILE | grep -i -- $_flag_s

    else if set -q _flag_g
        test -f $MEM_MASTER; or begin
            echo "mem: master file not found at $MEM_MASTER" 1>&2
            return 1
        end
        cp -f $MEM_MASTER $MEM_FILE
        echo "copied $MEM_MASTER → $MEM_FILE"

    else
        _usage
        return 1
    end
end
