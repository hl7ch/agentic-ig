#!/bin/bash
# Writes the context for a follow-up run to stdout: the original issue with its
# comments, then every comment, review and inline review comment of the pull
# request. Run it inside a checkout of the pull request branch.
#
# Usage: agent-pr-context.sh <issue-number or empty> <pr-number>
# Needs GH_TOKEN and GITHUB_REPOSITORY.
set -euo pipefail

issue="$1"
pr="$2"
repo="$GITHUB_REPOSITORY"

if [ -z "$issue" ]; then
  echo "# No issue is linked to this pull request by its branch name."
elif ! gh issue view "$issue" --repo "$repo" \
  --json number,title,author,body,comments \
  --template '# Issue #{{.number}}: {{.title}}

Opened by {{.author.login}}.

{{.body}}
{{range .comments}}
---
## Issue comment by {{.author.login}} on {{.createdAt}}

{{.body}}
{{end}}'; then
  echo "# Issue #${issue} could not be read."
fi

echo
"$(dirname "$0")/agent-roles.sh" "$issue" "$pr"
echo "# Pull request #${pr}"
echo
gh pr view "$pr" --repo "$repo" --json title,author,body \
  --template 'Title: {{.title}}
Opened by {{.author.login}}.

## Description

{{.body}}
'
echo
echo "Last commit on the branch: $(git log -1 --format='%cI by %an')"
echo
echo "## Conversation"
echo
gh api --paginate "repos/${repo}/issues/${pr}/comments" --jq '.[] |
  "### Comment by \(.user.login) on \(.created_at)\n\n\(.body)\n"'

echo "## Reviews"
echo
gh api --paginate "repos/${repo}/pulls/${pr}/reviews" --jq '.[] |
  select((.body // "") != "" or .state == "CHANGES_REQUESTED") |
  "### Review by \(.user.login), \(.state), on \(.submitted_at)\n\n\(.body)\n"'

echo "## Inline review comments"
echo
gh api --paginate "repos/${repo}/pulls/${pr}/comments" --jq '.[] |
  "### On \(.path), line \(.line // .original_line // "unknown"), by \(.user.login) on \(.created_at)\n\n\(.body)\n"'
