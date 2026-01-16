#!/bin/bash
read -r pct cwd < <(jq -r '[(.context_window.used_percentage // 0), (.cwd // "")] | @tsv')

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
	((added > 0)) && out+=" \033[38;5;2m+ \033[38;5;8m${added}  "
	((removed > 0)) && out+="\033[38;5;1m- \033[38;5;8m${removed}  "
fi

((pct > 0)) && { ((pct > 40)) && out+="\033[38;5;1m● ${pct}% | run /clear  " || out+="\033[38;5;2m● ${pct}%  "; }
[[ -n "$branch" ]] && out+="\033[38;5;5m⎇ \033[38;5;8m${branch} "

[[ -n "$out" ]] && printf '%b\033[0m' "$out"
