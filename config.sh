#!/bin/bash

set -e

export username=webuser
export password='secret'
export baseurl=https://localhost:8443
export site=default

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. "$DIR/unifi.sh"

curl_cmd="$curl_cmd --fail"