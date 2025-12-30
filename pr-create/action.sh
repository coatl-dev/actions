#!/usr/bin/env bash

# Parse INPUT_ADDITIONAL_ARGS into an array so multiple args are preserved
ADDITIONAL_ARGS_ARR=()
if [ -n "${INPUT_ADDITIONAL_ARGS:-}" ]; then
	# split into array on IFS (whitespace)
	read -r -a ADDITIONAL_ARGS_ARR <<< "$INPUT_ADDITIONAL_ARGS"
fi

if [ -n "$INPUT_TITLE" ] && [ -n "$INPUT_BODY_FILE" ]; then
	# Use title and body-file (if provided)
	gh pr create \
		--title "$INPUT_TITLE" \
		--body-file "$INPUT_BODY_FILE" \
		"${ADDITIONAL_ARGS_ARR[@]}"
elif [ -n "$INPUT_TITLE" ] && [ -n "$INPUT_BODY" ]; then
	# Use title and body (if provided)
	gh pr create \
		--title "$INPUT_TITLE" \
		--body "$INPUT_BODY" \
		"${ADDITIONAL_ARGS_ARR[@]}"
else
	# Use commit info for title and body
	gh pr create --fill "${ADDITIONAL_ARGS_ARR[@]}"
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
