#!/bin/bash

SRC=$1
DST=$2

oneclient -i $MOUNTPOINT

mkdir -p $MOUNTPOINT/$DST
cp -r $SRC $MOUNTPOINT

oneclient -u $MOUNTPOINT
