#!/bin/bash

WORKERDIR=`realpath \`dirname $0\``
WIDTH=$1
HEIGHT=$2

shift; shift

BOTS=$*
NUMBOTS=`echo $BOTS | wc -w`

pushd $WORKERDIR
./runGame.sh $WIDTH $HEIGHT $NUMBOTS $BOTS

cat *.hlt > visualizer_pipe
rm *.hlt

popd

exit
