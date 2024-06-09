function gap
    set -l message (echo $argv | string join " ")
    git add .
    git commit -m $message
    git push
end
