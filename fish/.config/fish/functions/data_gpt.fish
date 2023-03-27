function data_gpt -a prompt data
    curl https://api.openai.com/v1/chat/completions -s \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_KEY" \
    -d '{
        "model": "gpt-3.5-turbo",
        "messages": [{"role": "user", "content": "'$prompt': '$data'"}],
        "temperature": 0.7
    }' | jq -r '.choices[0].message.content'
end
