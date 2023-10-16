#! /bin/bash
# shellcheck source=/dev/null

set -Eeuxo pipefail

export PATH="/usr/bin:${PATH}"  # To find `id`
source /etc/profile  # Makes python and other executables findable

function process_file() {
  local file="$1"
  command=$(grep -m 1 "#    pip-compile" "$file" | sed 's/#    pip-compile/pip-compile --upgrade/')
  eval "$command"
}

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
