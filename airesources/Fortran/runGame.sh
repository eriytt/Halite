#!/bin/bash

gfortran -o my_bot hlt.f95 my_bot.f95
gfortran -o random_bot hlt.f95 random_bot.f95
./halite -d "30 30" "./random_bot" "./my_bot"