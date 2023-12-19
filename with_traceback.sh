#!/usr/bin/env bash
#

set -Eeuo pipefail

source ./bash_traceback.sh

my_main_func() {
  middle
}

middle() {
  inner
}

inner() {
  echo 'Before bad command.'
  # The next line will throw an error
  badcommand \
    --arg1 "${aaa}" \
    --arg2 "${bbb}" \
    "${ccc}" \
    "qwer" \
  ;
}

throw_exception () {
  local _code="${1:-0}"
  local -a _output=(
    #"$(print_environment)"
    "$(print_traceback "${_code}")"
  )
  printf '%s\n' "${_output[@]}" >&2
  #notify-send -- "$(echo "${_output[@]}")"
  exit "${_code}"
}

trap 'throw_exception "${?}"' ERR

# -----

echo 'START'

# Some local variables
aaa=1
bbb=23
ccc='asdfasdf'

my_main_func                      # < --- This will eventually fail

echo 'This is unreachable.'
