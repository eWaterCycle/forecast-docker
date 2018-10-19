#!/bin/bash

SRC=$1
DST=$2

MOUNTPOINT=/mnt/onedata
oneclient $MOUNTPOINT

mkdir -p $MOUNTPOINT/$DST
cp -r $SRC $MOUNTPOINT/$DST/

oneclient -u $MOUNTPOINT
