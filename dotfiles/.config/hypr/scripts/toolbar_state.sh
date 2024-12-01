#!/usr/bin/env bash

LOCK=/tmp/expand_toolbar.lock

# Set initial state to expand by deleting the LOCK file.
if [ -f "$LOCK" ]; then
    rm LOCK
fi

while true; do
    if [ -f "$LOCK" ]; then
        echo '{"text":"󰁔","tooltip":"Collapse"}'
    else
        echo '{"text":"󰁍","tooltip":"Expand"}'
    fi
    sleep 1
done
