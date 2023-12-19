#!/usr/bin/env bash
#

set -euo pipefail

source ./source_code.sh

source ./bash_traceback.sh

throw_exception () {
  print_environment
  print_traceback "${1}" "${2}"
}

trap 'throw_exception $LINENO ${?}' ERR

# -----
echo 'START'

# Some local variables
aaa=1
bbb=23
ccc='asdfasdf'

# <---- The next function call will eventually fail
my_main_func "${aaa}" "${bbb}" "${ccc}"

echo 'This is unreachable.'
