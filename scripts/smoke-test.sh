#!/usr/bin/env bash
set -euo pipefail

if [[ "${CI:-}" != "true" ]]; then
  echo "This smoke test is CI-only because it removes ~/.RTM on the test runner."
  exit 1
fi

RTM="${1:-./rtm}"
RTM="$(realpath "$RTM")"

cleanup() {
  rm -rf "$HOME/.RTM"
}
trap cleanup EXIT
cleanup

assert_contains() {
  local output="$1"
  local expected="$2"

  if ! grep -Fq "$expected" <<<"$output"; then
    echo "Expected output to contain: $expected"
    echo "Actual output:"
    echo "$output"
    exit 1
  fi
}

"$RTM" add First task
output=$("$RTM" ls)
assert_contains "$output" "First task"
assert_contains "$output" "TODO"

"$RTM" inp 1
output=$("$RTM" ls)
assert_contains "$output" "INP"

"$RTM" stop 1
output=$("$RTM" ls)
assert_contains "$output" "STOP"

"$RTM" undo 1
output=$("$RTM" ls)
assert_contains "$output" "TODO"

printf 'Edited task\n' | "$RTM" edit 1
output=$("$RTM" ls)
assert_contains "$output" "Edited task"

"$RTM" done 1
output=$("$RTM" ls)
assert_contains "$output" "DONE"

"$RTM" del 1
output=$("$RTM" ls)
if grep -Fq "Edited task" <<<"$output"; then
  echo "Task still exists after delete"
  exit 1
fi

echo "RTM smoke test passed"
