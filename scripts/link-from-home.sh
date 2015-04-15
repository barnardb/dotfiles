#!/bin/sh
set -euo pipefail

error() {
    printf '\e[31m%s\e[0m\n' "error: $1"
    exit 1
} >&2

file="$1"
contentless_file="${file#contents/}"
[ "${contentless_file}" != "${file}" ] || error "${file} doesn't appear to be in the contents directory"
home_file="$HOME/${contentless_file}"
home_parent="$(dirname "${home_file}")"
original_relative_to_home_parent="$(python -c "import os.path; print os.path.relpath('${file}', '${home_parent}')")"

if [ -h "${home_file}" ]; then
    current_path="$(readlink "${home_file}")"
    [ "${current_path}" = "${original_relative_to_home_parent}" ] || error "cannot link ${home_file} to ${original_relative_to_home_parent} because it is already linked to ${current_path}"
else
    ! [ -e "${home_file}" ] || error "${home_file} already exists but is not a symbolic link"
    mkdir -p "$(dirname "${home_file}")"
    ln -s "${original_relative_to_home_parent}" "${home_file}"
fi
