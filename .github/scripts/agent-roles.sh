#!/bin/bash
# Prints who is a maintainer among the people who wrote on the given issues and
# pull requests. A maintainer is someone with write access to the repository.
# GitHub's "author association" is not used for this: for a person whose
# organisation membership is private it reads CONTRIBUTOR to a workflow.
#
# Usage: agent-roles.sh <issue-or-pr-number>...   (empty arguments are skipped)
# Needs GH_TOKEN and GITHUB_REPOSITORY.
set -uo pipefail

repo="$GITHUB_REPOSITORY"
logins=$(
  for n in "$@"; do
    [ -z "$n" ] && continue
    gh api "repos/${repo}/issues/${n}" --jq '.user.login' 2>/dev/null
    gh api --paginate "repos/${repo}/issues/${n}/comments" --jq '.[].user.login' 2>/dev/null
    gh api --paginate "repos/${repo}/pulls/${n}/reviews" --jq '.[].user.login' 2>/dev/null
    gh api --paginate "repos/${repo}/pulls/${n}/comments" --jq '.[].user.login' 2>/dev/null
  done | grep -v '^{' | sort -u
)

echo "# Roles"
echo
echo "This list is the only source for who is a maintainer."
echo
for login in $logins; do
  case "$login" in
    *"[bot]") echo "- ${login}: automation, not a person" ;;
    *)
      permission=$(gh api "repos/${repo}/collaborators/${login}/permission" --jq '.permission' 2>/dev/null || echo unknown)
      case "$permission" in
        admin|maintain|write) echo "- ${login}: maintainer (${permission} access to the repository)" ;;
        unknown) echo "- ${login}: unknown, the permission could not be read; treat as contributor" ;;
        *) echo "- ${login}: contributor (no write access)" ;;
      esac ;;
  esac
done
echo
