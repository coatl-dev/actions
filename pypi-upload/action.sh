#!/usr/bin/env bash
# shellcheck source=/dev/null

export PATH="/usr/bin:${PATH}"  # To find `id`
source /etc/profile  # Makes python and other executables findable

cd "${INPUT_WORKING_DIRECTORY}" || exit 1

python -m build

if [[ "${TWINE_CHECK}" == "true" ]]; then
	python -m twine check dist/*
fi

if [[ "${INPUT_DRY_RUN}" == "true" ]]; then
	echo "Dry run enabled, not uploading the package."
	exit 0
elif [[ -z "${TWINE_PASSWORD}" ]]; then
	echo "TWINE_PASSWORD is not set."
	exit 1
else
	python -m twine upload --verbose dist/*
fi
