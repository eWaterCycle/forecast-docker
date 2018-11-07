#!/bin/bash

SRC=$1
DST=$2

export MOUNTPOINT=/mnt/onedata
mkdir -p $MOUNTPOINT
oneclient

cp -r $MOUNTPOINT/$SRC $DST/

oneclient -u $MOUNTPOINT
