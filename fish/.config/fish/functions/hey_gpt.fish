function hey_gpt -a prompt
    set gpt (curl https://api.openai.com/v1/chat/completions -s \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_KEY" \
    -d '{
        "model": "gpt-3.5-turbo",
        "messages": [{"role": "assistant", "content": "'$prompt'"}],
        "temperature": 0.7
    }')
    set content (echo $gpt | jq -r '.choices[0].message.content')
    echo $content
end
