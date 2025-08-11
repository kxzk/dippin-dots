#!/usr/bin/env fish
# linear.fish — Create a Linear issue (title only), then switch to its suggested git branch.

function fail
    printf '%s\n' (set_color red)"✖ $argv"(set_color normal) 1>&2
    exit 1
end

for b in curl jq git
    type -q $b; or fail "$b is required"
end

# Require env
set -q LINEAR_API_KEY; or fail "Set LINEAR_API_KEY in your environment."
set -q LINEAR_TEAM_ID; or fail "Set LINEAR_TEAM_ID in your environment."

# Title (all args joined)
test (count $argv) -gt 0; or fail "Usage: linear.fish <issue title>"
set -l title (string join " " $argv)

# GraphQL mutation
set -l gql 'mutation Create($input: IssueCreateInput!) {
  issueCreate(input: $input) {
    success
    issue { identifier url branchName }
  }
}'

set -l payload (jq -n --arg q "$gql" --arg teamId "$LINEAR_TEAM_ID" --arg title "$title" \
  '{ query: $q, variables: { input: { teamId: $teamId, title: $title } } }')

set -l resp (curl -sS https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  --data "$payload")

# API error surfacing
set -l msg (echo $resp | jq -r '.errors[0].message? // empty')
test -n "$msg"; and begin
    echo $resp | jq .
    fail "Linear API error: $msg"
end

test (echo $resp | jq -r '.data.issueCreate.success') = true; or fail "Issue creation failed."

set -l identifier (echo $resp | jq -r '.data.issueCreate.issue.identifier')
set -l url (echo $resp | jq -r '.data.issueCreate.issue.url')
set -l branch (echo $resp | jq -r '.data.issueCreate.issue.branchName')

# Safety: ensure we're in a repo and branch is non-empty
git rev-parse --is-inside-work-tree >/dev/null 2>&1; or fail "Run this inside a Git repository."
test -n "$branch"; or fail "Linear returned an empty branch name."

# Create or switch to branch
if git rev-parse --verify --quiet "$branch" >/dev/null
    git switch "$branch" 2>/dev/null; or git checkout "$branch"; or fail "Couldn't switch to '$branch'."
else
    git switch -c "$branch" 2>/dev/null; or git checkout -b "$branch"; or fail "Couldn't create '$branch'."
end

printf "✅ %s — %s\n🌐 %s\n→ Switched to branch: %s\n" "$identifier" "$title" "$url" "$branch"
