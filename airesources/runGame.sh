#!/bin/bash

if [ ! -f run.sh ]; then
    echo "You shoud be in a bot catalog when running this script"
    echo "For example:"
    echo "\$ cd C++"
    echo "\$ ../`basename $0`"
    exit -1
fi

rm -f *.hlt

docker run --rm -t -v "$PWD":/bot -w /bot "learningwell/halite_dev" /bin/bash -c "ln -s /halite . ; /bot/runGame.sh"

if [ ! $? ]; then
    echo "Run game failed"
    exit -1
fi

if [ `uname` == "Linux" ]; then
    PLATFORM="linux-x64"
    ../../../Halite-Visualizer-$PLATFORM/Halite-Visualizer dummy *.hlt
else 
    PLATFORM="darwin-x64"
    ../../../Halite-Visualizer-$PLATFORM/Halite-Visualizer.app/Contents/MacOS/Halite-Visualizer dummy *.hlt
fi

