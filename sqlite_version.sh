#!/bin/bash
echo $1 | awk -F '.' '{printf "%1d%02d%04d\n", $1, $2, $3}'
