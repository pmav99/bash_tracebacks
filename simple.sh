#!/usr/bin/env bash
#

set -euo pipefail

source ./source_code.sh

source ./bash_traceback.sh

trap 'print_traceback $LINENO ${?}' ERR

# -----
echo 'START'

# Some local variables
aaa=1
bbb=23
ccc='asdfasdf'

# <---- The next function call will eventually fail
my_main "${aaa}" "${bbb}" "${ccc}"

echo 'This is unreachable.'
