function hey_gpt
    set prompt \'(echo $argv | string join ' ')\'
    set gpt (curl https://api.openai.com/v1/chat/completions -s \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_KEY" \
    -d '{
        "model": "gpt-4",
        "messages": [{"role": "user", "content": "'$prompt'"}],
        "temperature": 1.0,
        "stream": true
    }')
    for text in $gpt
        if test $text = 'data: [DONE]'
            break
        else if string match -q --regex "role" $text
            continue
        else if string match -q --regex "content" $text
            echo -n $text | string replace 'data: ' '' | jq -r -j '.choices[0].delta.content'
            echo -n $text | string replace 'data: ' '' | jq -r -j '.choices[0].delta.content' >> tmp.txt
        else
            continue
        end
    end
    echo ''
    echo ''
    set now (date +%Y-%m-%d_%H-%M-%S)
    set prompt_fmt (echo $prompt | string replace -a "'" '' | tr ' ' '_')
    set filename $now'__'$prompt_fmt'.md'
    touch $filename
    cat tmp.txt >> $filename
    mv $filename ~/Desktop/gpt-logs/
    rm tmp.txt
    cd ~/Desktop/gpt-logs/
    git add .
    git commit -m "new log"
    git push
    cd -
end
