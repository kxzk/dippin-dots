function bro
    set prompt (echo $argv | string join ' ')
    set temp_file (mktemp)
    set response (curl https://api.openai.com/v1/chat/completions -s \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d '{
        "model": "gpt-4.1-mini-2025-04-14",
        "messages": [{"role": "user", "content": "'$prompt'"}],
        "temperature": 0.0
    }')

    echo $response | jq -r '.choices[0].message.content' >$temp_file
    bat --style=plain --theme gruvbox-dark --language=markdown $temp_file
    rm $temp_file
end
