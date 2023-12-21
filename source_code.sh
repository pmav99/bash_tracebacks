#!/usr/bin/env bash
#

set -euo pipefail
source ./bash_traceback.sh

my_main() {
  echo main_func called with arguments: "${@}"
  middle
}

middle() {
  inner
}

inner() {
  echo 'Before bad command.'
  # <---- The next line will throw an error
  timeout 0.01 curl --fail https://example.com
}
