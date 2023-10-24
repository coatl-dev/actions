#!/bin/bash

if [ -z "$INPUT_SKIP_REPOS" ]; then
    while IFS='' read -r repo || [ -n "${repo}" ]; do
        pre-commit autoupdate --repo "$repo"
    done < <(
        grep -Eo 'https://[a-zA-Z0-9./?=_%:-]*' .pre-commit-config.yaml
    )
else
    while IFS='' read -r repo || [ -n "${repo}" ]; do
        pre-commit autoupdate --repo "$repo"
    done < <(
        grep -Eo 'https://[a-zA-Z0-9./?=_%:-]*' .pre-commit-config.yaml |
        grep -iEwv "$INPUT_SKIP_REPOS"
    )
fi
