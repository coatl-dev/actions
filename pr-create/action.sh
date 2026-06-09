#!/usr/bin/env bash
set -euo pipefail

BASE_ARG=()
if [ -n "${INPUT_BASE_BRANCH:-}" ]; then
	BASE_ARG=(--base "$INPUT_BASE_BRANCH")
fi

if [ -n "$INPUT_TITLE" ] && [ -n "$INPUT_BODY_FILE" ]; then
	# Use title and body-file (if provided)
	gh pr create \
		--title "$INPUT_TITLE" \
		--body-file "$INPUT_BODY_FILE" \
		"${BASE_ARG[@]}"
elif [ -n "$INPUT_TITLE" ] && [ -n "$INPUT_BODY" ]; then
	# Use title and body (if provided)
	gh pr create \
		--title "$INPUT_TITLE" \
		--body "$INPUT_BODY" \
		"${BASE_ARG[@]}"
else
	# Use commit info for title and body
	gh pr create --fill "${BASE_ARG[@]}"
fi

if [ "$INPUT_AUTO_MERGE" == "yes" ] && [ "$INPUT_DELETE_BRANCH" == "yes" ]; then
	# Merge pull request and delete branch
	gh pr merge \
		--auto \
		--delete-branch \
		--squash
elif [ "$INPUT_AUTO_MERGE" == "yes" ]; then
	# Merge pull request
	gh pr merge \
		--auto \
		--squash
fi
