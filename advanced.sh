#!/usr/bin/env bash
#

set -euo pipefail

source ./source_code.sh

source ./bash_traceback.sh

throw_exception () {
  #print_environment
  variables=$(print_variables aaa bbb ccc ddd eee)
  traceback="$(print_traceback "${1}" "${2}" /dev/stdout)"
  if [[ -x "$(command -v notify-send)" ]]; then
    notify-send -- "${traceback}"
    notify-send -- "${variables}"
  fi
  printf "%s\n" "${variables}" > /dev/stderr
  printf "%s\n" "${traceback}" > /dev/stderr
}

trap 'throw_exception $LINENO ${?}' ERR

# -----
echo 'START'

# Some local variables
aaa=1
bbb=23
ccc='asdfasdf'
eee=''

# <---- The next function call will eventually fail
my_main "${aaa}" "${bbb}" "${ccc}"

echo 'This is unreachable.'
