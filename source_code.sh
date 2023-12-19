#!/usr/bin/env bash
#

set -euo pipefail

my_main_func() {
  echo Called with arguments: "${@}"
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
