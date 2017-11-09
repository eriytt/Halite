#!/bin/bash

# Team Number (Change this)
TEAM_NUMBER="19"
SSH_SERVER="${1:-well.learningwell.se}"

../compileInDocker.sh

docker run --rm -it -v "$PWD":/bot -w / "learningwell/halite_dev" /publish.sh $TEAM_NUMBER $SSH_SERVER