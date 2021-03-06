#!/bin/bash

ENVIRONMENT="halite"
RUNFILE="run.sh"
WORKINGPATH="workingPath"
BOTPREFIX="/home/halite/teams"

if [ ! -f $ENVIRONMENT ]; then
    echo "NO ENVIRONMENT!!"
    cd ../environment
    make clean
    make 
    mv halite ../worker
    cd ../worker
fi

WIDTH=$1
HEIGHT=$2
NUMBOTS=$3
BOTSTART=4

mkdir $WORKINGPATH
cp $ENVIRONMENT $WORKINGPATH
for BOT in ${@:$BOTSTART:$NUMBOTS}; do
    cp -a "$BOTPREFIX/$BOT" $WORKINGPATH;
    if [ -x "$WORKINGPATH/$BOT/prerun.sh" ]; then
        "$WORKINGPATH/$BOT/prerun.sh"
    fi
done

cd $WORKINGPATH
for BOT in ${@:$BOTSTART:$NUMBOTS}; do
    chmod +x "$BOT/$RUNFILE";
    chmod 755 "$BOT/$RUNFILE";
done;

BOTSTARTCOMMANDS=""
for i in `seq $BOTSTART $((4+$NUMBOTS-1))`;
do
    BOT=${!i};
    
    BOTNAMEINDEX=$(($i+$NUMBOTS));
    BOTNAME=${!BOTNAMEINDEX};

    #BOTSTARTCOMMANDS+="\"/usr/bin/docker run --net=none --memory='350m' --cpu-shares=1024 --storage-opt size=10G -i -v $PWD/$BOT:$PWD/$BOT mntruell/halite_sandbox:latest sh -c 'cd $PWD/$BOT && ./$RUNFILE'\" "
    BOTSTARTCOMMANDS+="\"/usr/bin/docker run --net=none --memory='350m' --cpu-shares=1024 -i -v $PWD/$BOT:$PWD/$BOT:ro mntruell/halite_sandbox:latest sh -c 'cd $PWD/$BOT && ./$RUNFILE'\" "
done

eval "chmod +x $ENVIRONMENT"

RUN_GAME_COMMAND="./$ENVIRONMENT -d \"$WIDTH $HEIGHT\" $BOTSTARTCOMMANDS"
echo $RUN_GAME_COMMAND;
eval $RUN_GAME_COMMAND;

docker stop  $(docker ps -aq) >/dev/null
docker rm -v $(docker ps -aq) >/dev/null

#rm /run/network/ifstate.veth*

mv *.hlt ../
mv *.log ../
cd ..
rm -rf $WORKINGPATH
