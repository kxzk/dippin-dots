function prlink
    set -l alert (echo "@$argv")
    set -l prlinks (gh pr list --author '@me' --json 'title' --json 'url' | jq '.[]' | jq -r '[.url, .title] | @tsv' | sed 's/\t/ -> /g')
    begin echo $alert; echo $prlinks; end | open -e -f
end
