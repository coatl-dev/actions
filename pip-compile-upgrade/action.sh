#!/usr/bin/env bash
# shellcheck source=/dev/null

export PATH="/usr/bin:${PATH}"  # To find `id`
source /etc/profile  # Makes python and other executables findable

function process_file() {
  local file="$1"
  local use_config="$INPUT_USE_CONFIG"
  local config_file="$INPUT_CONFIG_FILE"

  command=$(grep -m 1 "#    pip-compile" "$file")
  if [ -n "$command" ]; then
    if [ "$use_config" == "yes" ]; then
      if [ -f "$config_file" ]; then
        file_name=$(grep -m 1 -E "#    pip-compile.*(pyproject\.toml|setup\.cfg|setup\.py|[^ ]+\.in)" "$file" | sed -E "s/.*(#    pip-compile.* (pyproject\.toml|setup\.cfg|setup\.py|[^ ]+\.in)).*/\2/")
        upgrade_command="pip-compile --upgrade --config $config_file $file_name"
        eval "$upgrade_command"
      else
        exit 1
      fi
    else
      upgrade_command=$(grep -m 1 "#    pip-compile" "$file" | sed "s/#    pip-compile/pip-compile --upgrade/")
      eval "$upgrade_command"
    fi
  else
    exit 1
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
