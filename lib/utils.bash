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

# NOTE: You might want to remove this if <YOUR TOOL> is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}
