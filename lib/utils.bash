#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/google/go-containerregistry"
GH_API_REPO="https://api.github.com/repos/google/go-containerregistry"

TOOL_NAME="crane"
TOOL_TEST="version"
PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

list_all_versions() {
  curl "${curl_opts[@]}" "${GH_API_REPO}/releases" | grep -oE "tag_name\": *\".{1,15}\"," | sed 's/tag_name\": *\"v//;s/\",//'
}

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}
