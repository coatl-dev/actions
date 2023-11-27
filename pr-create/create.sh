#!/bin/bash

if [ -n "$INPUT_TITLE" ] && [ -n "$INPUT_BODY_FILE" ]; then
    # Use title and body-file (if provided)
    gh pr create \
        --title "$INPUT_TITLE" \
        --body-file "$INPUT_BODY_FILE"
elif [ -n "$INPUT_TITLE" ] && [ -n "$INPUT_BODY" ]; then
    # Use title and body (if provided)
    gh pr create \
        --title "$INPUT_TITLE" \
        --body "$INPUT_BODY"
else
    # Use commit info for title and body
    gh pr create --fill
fi

if [ "$INPUT_AUTO_MERGE" == "yes" ]; then
    # Merge pull request
    gh pr merge \
        --auto \
        --delete-branch \
        --squash
fi
