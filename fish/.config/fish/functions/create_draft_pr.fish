function create_draft_pr
    set pr_title (git branch --show-current | string replace -a '-' ' ')
    gh pr create --title $pr_title --draft
end
