function bro
    set prompt (echo $argv | string join ' ')
    # add format to end of prompt
    set prompt "$prompt MUST RETURN RESPONSE IN MARKDOWN FORMAT"
    set temp_file (mktemp)

    set json_payload (printf '{
        "model": "gpt-5-nano-2025-08-07",
        "reasoning_effort": "low",
        "messages": [{"role": "user", "content": %s}]
    }' (echo $prompt | jq -Rs .))

    set response (curl https://api.openai.com/v1/chat/completions -s \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "$json_payload")

    echo $response | jq -r '.choices[0].message.content // .error.message // empty' >$temp_file

    if test -s $temp_file
        bat --style=plain --theme=OneHalfDark --language=markdown $temp_file
    else
        echo "API error or empty response"
        echo $response | jq '.'
    end

    rm -f $temp_file
end
