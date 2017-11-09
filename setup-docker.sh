#!/bin/bash


echo "Importing docker container, this might take a while!"

docker load < halite_dev.latest.tar
chmod +x ./Halite/*.sh
chmod +x ./Halite/*/*.sh

echo "Done!"

