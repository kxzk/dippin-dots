function prlink
    set -l alert (echo "@$argv")
    set -l prlinks (gh pr list --author '@me' --json 'title' --json 'url' | jq '.[]' | jq -r '"\(.url) -> \(.title)"')
    begin echo $alert; echo \n$prlinks; end | open -e -f
end
