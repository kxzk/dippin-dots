function img_gpt -a prompt
    set create_img (curl https://api.openai.com/v1/images/generations -s \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_KEY" \
    -d '{
        "prompt": "'$prompt'",
        "n": 1,
        "size": "1024x1024"
    }')
    echo $create_img | jq
    set url (echo $create_img | jq -r '.data[0].url')
    set rand_num (random 1 1000000)
    curl -s $url -o img-"$rand_num".png
end
