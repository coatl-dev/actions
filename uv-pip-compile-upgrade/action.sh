#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export PATH="/usr/bin:${PATH}"  # To find `id`
# shellcheck source=/dev/null
source /etc/profile  # Makes python and other executables findable

function process_file() {
	local file="$1"
	local raw_command
	raw_command=$(grep -m 1 '^#[[:space:]]*uv pip compile' "$file" | sed 's/^#[[:space:]]*//') || true
	if [ -z "$raw_command" ]; then
		exit 1
	fi

	local -a command_parts
	read -r -a command_parts <<< "$raw_command"
	if [ "${command_parts[0]:-}" != "uv" ]; then
		exit 1
	fi

	local -a command
	command=("${command_parts[@]}" "--upgrade")

	"${command[@]}"
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
