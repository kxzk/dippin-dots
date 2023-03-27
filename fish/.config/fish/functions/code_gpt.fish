function code_gpt -a input instruction
    curl https://api.openai.com/v1/edits -s \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_KEY" \
    -d '{
        "model": "code-davinci-edit-001",
        "input": "'$input'",
        "instruction": "'$instruction'",
    }' | jq -r '.choices[0].text'
end
