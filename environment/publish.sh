#!/bin/bash

TEAM_NUMBER=$1
SSH_SERVER="$2"

tar -czvf /publish.tar.gz /bot
scp -i /id_rsa /publish.tar.gz halite@$SSH_SERVER:"teams/$TEAM_NUMBER"