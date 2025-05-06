#!/usr/bin/env bash
# shellcheck source=/dev/null

export PATH="/usr/bin:${PATH}"  # To find `id`
source /etc/profile  # Makes python and other executables findable

function process_file() {
  local file="$1"
  local use_config="$INPUT_USE_CONFIG"
  local config_file="$INPUT_CONFIG_FILE"

  if [ "$use_config" == "yes" ]; then
    if [ -f "$config_file" ]; then
      in_file="${file%.txt}.in"
      pip-compile --upgrade --config "$config_file" "$in_file"
    else
      exit 1
    fi
  else
    command=$(grep -m 1 "#    pip-compile" "$file" | sed 's/#    pip-compile/pip-compile --upgrade/')
    if [ -n "$command" ]; then
      eval "$command"
    else
      pip-compile "$file"
    fi
  fi
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
