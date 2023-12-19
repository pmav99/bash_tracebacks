#!/usr/bin/env bash

# Inspired by: https://github.com/bash-utilities/trap-failure/blob/714c6b9370df4e5e643bdc075c0db6bbe17555ed/failure.sh
#

set -o errtrace

print_environment() {
  local -a _output
  _output=(
    '=== ENVIRONMENT ==='
    "$(set -o posix ; set)"
    '=== ENVIRONMENT ==='
  )
  printf '%s\n' "${_output[@]}"
}

print_traceback () {
  local -a _output
  _lineno=${1}
  _exit_code=${2}

  _output+=(
    '=== TRACEBACK ==='
    "CLI_arguments  : $(tr '\0' ' ' < /proc/$$/cmdline)"
    "exit_code      : ${_exit_code}"
    "failed_command : ${BASH_COMMAND}"
    'stacktrace     :'
  )

  # slice arrays
  # The first element is the print_traceback function which we don't need it in the output
  _funcname=("${FUNCNAME[@]:1}")
  _bash_source=("${BASH_SOURCE[@]:1}")
  _bash_lineno=("${BASH_LINENO[@]:1}")
  for (( i=0; i<"${#_funcname[@]}"; ++i ))
  #for (( i="${#_funcname[@]}"-1; i>=0; i-- ))
  do
    if [[ "${_bash_lineno[$i]}" -eq "${_lineno}" ]]; then
      continue
    fi
    _output+=("  - ${_bash_source[i]}:${BASH_LINENO[i]}:${_funcname[i]}")
  done
  _output+=('=== TRACEBACK ===')
  printf '%s\n' "${_output[@]}" > /dev/stderr
}
