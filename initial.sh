#!/usr/bin/env bash
#

set -Eeuo pipefail

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

# -----

echo 'START'

# Some local variables
aaa=1
bbb=23
ccc='asdfasdf'

my_main_func                      # < --- This will eventually fail

echo 'This is unreachable.'
