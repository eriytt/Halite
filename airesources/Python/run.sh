#!/bin/bash

cd `dirname $0`

if hash python3 2>/dev/null; then
    exec python3 MyBot.py
else
    exec python MyBot.py
fi
