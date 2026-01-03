#!/bin/bash
read -r current size cwd < <(jq -r '[
  (.context_window.current_usage | if . then .input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens else 0 end),
  (.context_window.context_window_size // 0),
  (.cwd // "")
] | @tsv')

out=""

if [[ -n "$cwd" ]]; then
	read -r tracked_added tracked_removed untracked_lines branch < <(
		cd "$cwd" 2>/dev/null || exit
		git diff HEAD --numstat 2>/dev/null | awk '{a+=$1; r+=$2} END {printf "%d %d ", a+0, r+0}'
		git ls-files --others --exclude-standard 2>/dev/null | xargs -r wc -l 2>/dev/null | tail -1 | awk '{printf "%d ", $1+0}'
		git rev-parse --abbrev-ref HEAD 2>/dev/null
	)
	added=$((tracked_added + untracked_lines))
	removed=$tracked_removed
	((added > 0)) && out+=" \033[38;2;158;206;106m+ \033[90m${added}  "
	((removed > 0)) && out+="\033[31m- \033[90m${removed}  "
fi

if ((size > 0)); then
	pct=$((current * 100 / size))
	((pct > 40)) && out+="\033[91m● ${pct}%!!  " || out+="\033[34m● ${pct}%  "
fi
[[ -n "$branch" ]] && out+="\033[35m⎇ \033[90m${branch} "

[[ -n "$out" ]] && printf '%b\033[0m' "$out"
