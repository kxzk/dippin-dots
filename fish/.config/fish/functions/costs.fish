function costs
    set -l DATE_CMD (date -v1d -v0H -v0M -v0S +%s)

    set -l URL "https://api.openai.com/v1/organization/costs?start_time=$DATE_CMD&bucket_width=1d"
    curl --silent "$URL" \
        -H "Authorization: Bearer $OPENAI_ADMIN_KEY" \
        -H "Content-Type: application/json" \
        | jq -r '
        .data[]
        | {day: (.start_time|strftime("%Y-%m-%d")),
           usd: (.results[0].amount.value // 0)}
      '
end
