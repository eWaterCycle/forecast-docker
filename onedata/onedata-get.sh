#!/bin/bash

SRC=$1
DST=$2

MOUNTPOINT=/mnt/onedata
oneclient $MOUNTPOINT

cp -r $MOUNTPOINT/$SRC $DST/

oneclient -u $MOUNTPOINT
