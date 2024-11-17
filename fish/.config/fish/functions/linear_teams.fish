function linear_teams
    # Check if LINEAR_API_KEY is set
    if test -z "$LINEAR_API_KEY"
        echo "Error: LINEAR_API_KEY environment variable is not set" >&2
        echo "Please set it with: set -gx LINEAR_API_KEY 'your_api_key'" >&2
        return 1
    end

    # GraphQL query to fetch teams
    set teams_query 'query Teams {
        teams {
            nodes {
                id
                name
            }
        }
    }'

    # Make the GraphQL request and process the response
    curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: $LINEAR_API_KEY" \
        https://api.linear.app/graphql \
        -d "{\"query\": "(echo $teams_query | jq -R -s .)"}" | jq -r '.data.teams.nodes[] | "\(.name): \(.id)"'
end

# Optional completions
complete -c linear_teams -f # No file completion needed
