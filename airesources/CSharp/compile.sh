#!/bin/bash

cd `dirname $0`

mcs -t:library -out:HaliteHelper.dll HaliteHelper.cs
mcs -reference:HaliteHelper.dll -out:RandomBot RandomBot.cs
