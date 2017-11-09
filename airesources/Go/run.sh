#!/bin/bash

cd `dirname $0`

export GOPATH="$(pwd)"
exec go run MyBot.go
