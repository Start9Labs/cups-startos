#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 5000 )); then
    exit 60
else
    curl --silent --fail cups.embassy &>/dev/null
    RES=$?
    if test "$RES" != 0; then
        echo "The Cups UI is unreachable" >&2
        exit 1
    fi
fi
