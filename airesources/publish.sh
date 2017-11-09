#!/bin/bash

# Team Number (Change this)
TEAM_NUMBER="1"
SSH_SERVER="${1:-well.learningwell.se}"

docker run --rm -t -v "$PWD":/bot -w / "learningwell/halite_dev" /publish.sh $TEAM_NUMBER $SSH_SERVER