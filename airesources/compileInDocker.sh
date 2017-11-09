#!/bin/bash

if [ ! -f run.sh ]; then
    echo "You shoud be in a bot catalog when running this script"
    echo "For example:"
    echo "\$ cd C++"
    echo "\$ ../`basename $0`"
    exit -1
fi

if [ ! -f compile.sh ]; then
    echo "This is not a compileable bot"
    exit -1
fi

docker run --rm -t -v "$PWD":/bot -w / "learningwell/halite_dev" /bot/compile.sh
