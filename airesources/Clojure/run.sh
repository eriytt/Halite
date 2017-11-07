#!/bin/bash

cd `dirname $0`

exec java -cp target/MyBot.jar RandomBot
