#!/bin/bash

scp -r 'halite@well.learningwell.se:/home/halite/teams/*' /home/halite/teams

for p in /home/halite/teams/*/publish.tar.gz; do
    pushd `dirname $p`
    tar -zxvf publish.tar.gz
    popd
done
