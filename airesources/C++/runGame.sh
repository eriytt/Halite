#!/bin/bash

g++ -std=c++11 MyBot.cpp -o MyBot
g++ -std=c++11 RandomBot.cpp -o RandomBot
./halite -d "30 30" "./MyBot" "./RandomBot"
