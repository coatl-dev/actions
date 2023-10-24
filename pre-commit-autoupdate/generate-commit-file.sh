#!/bin/bash

echo "build(deps): coatl-dev pre-commit autoupdate" > "${RUNNER_TEMP}/commit.txt"
{
    echo ""
    echo "updates:"
    git diff --unified=1 ../.pre-commit-config.yaml |
    grep 'https://[a-zA-Z0-9./?=_%:-]*' | sed -e 's/ \{2,\}/  /g'
} >> "${RUNNER_TEMP}/commit.txt"
