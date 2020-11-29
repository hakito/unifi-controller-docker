#!/bin/bash
set -e

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. "$DIR/config.sh"

unifi_login
unifi_backup
unifi_logout