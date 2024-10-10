function git_rm_lb
    git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
end
