#!/bin/bash

set -e

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

 . "$DIR/config.sh"

curl_cmd="curl --tlsv1 --silent --cookie ${cookie} --cookie-jar ${cookie} --insecure"

unifi_upload_backup() {
    if [ $# -lt 1 ] ; then
        echo "Usage: $0 <backup.unf>"
        return
    fi

    ${curl_cmd} --retry 10 --retry-delay 3 --retry-connrefused\
        -F "file=@$1" $baseurl/upload/backup -H 'X-Requested-With: XMLHttpRequest'\
        | sed -n 's/.*backup_id":"\([^"]\+\)".*/\1/p'
}

backup_id=`unifi_upload_backup $1`
echo Restoring backup $backup_id
$curl_cmd --data-binary "{\"cmd\":\"restore\",\"backup_id\":\"$backup_id\"}" $baseurl/api/cmd/backup
