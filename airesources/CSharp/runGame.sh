#!/bin/bash

mcs -t:library -out:HaliteHelper.dll HaliteHelper.cs
mcs -reference:HaliteHelper.dll -out:MyBot.exe MyBot.cs
mcs -reference:HaliteHelper.dll -out:RandomBot.exe RandomBot.cs 
./halite -d "30 30" "mono ./MyBot.exe" "mono ./RandomBot.exe"
