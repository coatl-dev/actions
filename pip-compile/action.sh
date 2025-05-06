#!/usr/bin/env bash
# shellcheck source=/dev/null

export PATH="/usr/bin:${PATH}"  # To find `id`
source /etc/profile  # Makes python and other executables findable

function process_file() {
  local file="$1"
  local config_file="$INPUT_CONFIG_FILE"
  local use_config="$INPUT_USE_CONFIG"

  if [ "$use_config" == "yes" ]; then
    local config_file="${file%.txt}.in"
    if [ -f "$config_file" ]; then
      echo "Using config file: $config_file"
      pip-compile --upgrade "$file" --config-file "$config_file"
    else
      echo "Config file not found: $config_file"
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
