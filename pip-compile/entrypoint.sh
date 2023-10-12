#! /bin/bash
# shellcheck source=/dev/null

set -Eeuo pipefail

export PATH="/usr/bin:${PATH}"  # To find `id`
source /etc/profile  # Makes python and other executables findable

function process_file() {
  set +e
  local file="$1"
  command=$(grep -m 1 "#    pip-compile" "$file" | sed 's/#    //' | sed 's/pip-compile/pip-compile --upgrade/')
  eval "$command"
  set -e
}

if [ -d "${INPUT_PATH}" ]; then
  cd "${INPUT_PATH}"
  for file in *.txt; do
    if [ -f "$file" ]; then
      process_file "$file"
    fi
  done
elif [ -f "$file" ]; then
  process_file "$file"
else
  exit 1
fi
