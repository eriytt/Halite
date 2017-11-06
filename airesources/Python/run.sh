#!/bin/bash

if hash python3 2>/dev/null; then
    exec python3 RandomBot.py
else
    exec python RandomBot.py
fi
