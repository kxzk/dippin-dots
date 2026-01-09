#!/bin/bash

read -r input
QUERY=${input#*'"query":"'}
QUERY=${QUERY%%\"*}

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
cd "$PROJECT_DIR" || exit 1

if [[ -d .git ]]; then
  git ls-files --cached --others --exclude-standard 2>/dev/null
else
  rg --files --hidden 2>/dev/null
fi | fzf --filter "$QUERY" | head -15
