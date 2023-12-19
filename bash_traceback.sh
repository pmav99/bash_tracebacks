#!/usr/bin/env bash

# Inspired by: https://github.com/bash-utilities/trap-failure/blob/714c6b9370df4e5e643bdc075c0db6bbe17555ed/failure.sh
#

set -o errtrace

print_environment() {
  local -a _output_array
  _output_array=(
    '=== ENVIRONMENT ==='
    "$(set -o posix ; set)"
    #"$(lowercase_variables)"
    '=== ENVIRONMENT ==='
  )
  printf '%s\n' "${_output_array[@]}"
}

print_traceback () {
  local _code="${1:-0}"
  local -a _output_array

  ## Workaround for read EOF combo tripping traps
  ((_code)) || return "${_code}"

  _output_array+=(
    '=== TRACEBACK ==='
    "CLI_arguments  : $(tr '\0' ' ' < /proc/$$/cmdline)"
    "exit_code      : ${_code}"
    "failed_command : ${BASH_COMMAND}"
    'stacktrace     :'
  )
  for i in "${!FUNCNAME[@]}"; do
    _output_array+=("  - ${BASH_SOURCE[i]}:${BASH_LINENO[i]}:${FUNCNAME[i]}")
  done
  _output_array+=('=== TRACEBACK ===')

  printf '%s\n' "${_output_array[@]}"
}
