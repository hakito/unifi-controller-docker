#!/bin/bash

touch /var/log/unifi/server.log
tail -F /var/log/unifi/server.log &

keepRunning=1
_term() {
    echo "[WRAPPER] Caught SIGTERM"
    keepRunning=0
    kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

service unifi start &
child=$!
wait "$child"; status=$?
if [ $status -ne 0 ]; then
    echo "[WRAPPER] Failed to start unifi: $status"
    [ $keepRunning -eq 1 ] && exit $status
else
    echo "[WRAPPER] Service started"
fi

while [ $keepRunning -eq 1 ]; do
    sleep 60 &
    child=$!

    ! wait "$child" && break

    service unifi status >/dev/null &

    child=$!
    wait "$child"

    PROCESS_1_STATUS=$?
    [ $keepRunning -ne 1 ] && break
    if [ $PROCESS_1_STATUS -ne 0 ]; then
        echo "[WRAPPER] One of the processes has already exited."
        exit 1
    fi
done

echo "[WRAPPER] Stopping unifi service"
service unifi stop; status=$?
if [ $status -ne 0 ]; then
    echo "[WRAPPER] Failed to stop unifi: $status"
    exit $status
fi
echo "[WRAPPER] Service stopped"
