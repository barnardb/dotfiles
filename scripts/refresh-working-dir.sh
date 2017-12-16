#!/bin/sh
set -euo pipefail

scripts_dir="$(dirname "$0")"

find contents -type f -print0 | xargs -0 -n1 "${scripts_dir}/link-from-home.sh"
