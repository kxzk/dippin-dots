#!/bin/bash
read -r current size cwd < <(jq -r '
  [
    (.context_window.current_usage | if . then .input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens else 0 end),
    (.context_window.context_window_size // 0),
    (.cwd // "")
  ] | @tsv
')

if [ "$size" -gt 0 ]; then
    printf '\033[48;2;35;37;51m\033[38;2;186;215;97m ⟨C⟩ %d%% \033[0m' "$((current * 100 / size))"
fi

if [ -n "$cwd" ] && [ -d "$cwd/.git" ]; then
    branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null) && \
        printf '\033[48;2;35;37;51m\033[38;2;195;154;201m ⟨B⟩ %s \033[0m' "$branch"
fi
