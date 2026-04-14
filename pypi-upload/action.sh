#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export PATH="/usr/bin:${PATH}"  # To find `id`
# shellcheck source=/dev/null
source /etc/profile  # Makes python and other executables findable

cd "${INPUT_WORKING_DIRECTORY}" || exit 1

python -m build

if [[ "${TWINE_CHECK}" == "true" ]]; then
	python -m twine check dist/*
fi

if [[ "${INPUT_DRY_RUN}" == "true" ]]; then
	echo "Dry run enabled, not uploading the package."
	exit 0
fi

if [[ -z "${TWINE_PASSWORD}" ]]; then
	echo "TWINE_PASSWORD is not set."
	exit 1
fi

python -m twine upload --non-interactive --verbose dist/*
