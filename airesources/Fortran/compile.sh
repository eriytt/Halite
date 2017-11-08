#!/bin/bash

cd `dirname $0`
gfortran -o random_bot hlt.f95 random_bot.f95
