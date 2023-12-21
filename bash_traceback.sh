#!/usr/bin/env bash
#
# Inspired by: https://gist.github.com/akostadinov/33bb2606afe1b334169dfbf202991d36?permalink_comment_id=4726328#gistcomment-4726328

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
  local -ir _lineno=${1}
  local -ir _exit_code=${2}
  local _stream="${3:-/dev/stderr}"

  # declare -p BASH_SOURCE
  # declare -p BASH_LINENO
  # declare -p FUNCNAME

  local -a _output+=(
    '=== TRACEBACK ==='
    "CLI_arguments  : $(tr '\0' ' ' < /proc/$$/cmdline)"
    "exit_code      : ${_exit_code}"
    "failed_command : ${BASH_COMMAND}"
    'stacktrace     :'
  )

  local -ir _stack_size=${#FUNCNAME[@]}
  local -i _i
  local -i _stack_index=0
  # we start the loop with 1 in order to skip the current function from the stacktrace
  for (( _i = 1; _i <= _stack_size; _i++ )); do
    # When print_traceback has been called from a trap callback then the
    # BASH_LINENO of the callback function is going to be wrong.
    # Its  actual value will be equal to the line number of the command that failed
    # When that is the case we should just skip the callback stack (i.e the first stack),
    if [[ "${_i}" -eq 1 && "${BASH_LINENO[$_i]}" -eq "${_lineno}" ]]; then
      continue
    fi
    _stack_index+=1
    local -i _line="${BASH_LINENO[$(( _i - 1 ))]}"
    local _src="${BASH_SOURCE[$_i]:-(stdin)}"
    local _func="${FUNCNAME[$_i]:-(__main__)}"
    # The very last stack has a line number equal to 0 which shouldn't offer much value to users
    # Therefore we remove it.
    if [[ $_line -eq 0 ]]; then
      continue
    fi
    _output+=("   ($_stack_index) $_src:$_line:$_func")
  done

  _output+=('=== TRACEBACK ===')
  printf '%s\n' "${_output[@]}" > "${_stream}"
}
