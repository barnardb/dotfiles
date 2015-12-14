#!/usr/bin/env bash
set -euo pipefail

usage() { echo "usage: $0"; }

show_help() {
    usage
    cat <<'EOF'

Refreshes all ~/*/dotfiles directories
EOF
}

usage_error() { echo "error: $1"; usage; exit 2; } >&2

while (( $# > 0 )); do
    case "$1" in
        -'?' | --help) show_help; exit;;
        --) shift; break;;
        -*) usage_error "unknown option $1" "Use '--' to separate arguments from options";;
        *) break;;
    esac
    shift
done

[ $# -eq 0 ] || usage_error "expected 0 arguments, got $#"

scripts_dir="$(dirname "$0")"
scripts_dir="$(realpath "${scripts_dir}")"

for directory in ~/*/dotfiles/; do
    echo "Refreshing ${directory}"
    cd "${directory}"
    "${scripts_dir}/refresh-working-dir.sh"
    echo
done
