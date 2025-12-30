#!/usr/bin/env bash
# shellcheck source=/dev/null

export PATH="/usr/bin:${PATH}"  # To find `id`
source /etc/profile  # Makes python and other executables findable

function process_file() {
	local file="$1"
	local extra_args="${INPUT_EXTRA_ARGS:-}"

	command=$(grep -m 1 "#    pip-compile" "$file")
	if [ -n "$command" ]; then
		upgrade_command=$(grep -m 1 "#    pip-compile" "$file" | sed "s/#    pip-compile/pip-compile --upgrade $extra_args/")
		eval "$upgrade_command"
	else
		exit 1
	fi
}

cd "${INPUT_WORKING_DIRECTORY}" || exit 1

if [ -d "${INPUT_PATH}" ]; then
	cd "${INPUT_PATH}" || exit
	for file in *.txt; do
		if [ -f "$file" ]; then
			process_file "$file"
		fi
	done
elif [ -f "${INPUT_PATH}" ]; then
	process_file "${INPUT_PATH}"
else
	exit 1
fi
