#!/bin/sh
set -euo pipefail

scripts_dir="$(dirname "$0")"

find contents -type f -print -exec "${scripts_dir}/link-from-home.sh" "{}" ";"
