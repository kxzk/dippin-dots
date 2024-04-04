function hey_gpt
    set prompt \'(echo $argv | string join ' ')\'
    set gpt (curl https://api.openai.com/v1/chat/completions -s \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d '{
        "model": "gpt-4-0125-preview",
        "messages": [{"role": "user", "content": "'$prompt'"}],
        "temperature": 1.0,
        "stream": true
    }')
    for text in $gpt
        if test $text = 'data: [DONE]'
            break
        else if string match -q --regex role $text
            continue
        else if string match -q --regex content $text
            echo -n $text | string replace 'data: ' '' | jq -r -j '.choices[0].delta.content'
        else
            continue
        end
    end
    echo ''
end
