#!/bin/bash

gcc MyBot.c -o MyBot
gcc RandomBot.c -o RandomBot
./halite -d "30 30" "./MyBot" "./RandomBot"
