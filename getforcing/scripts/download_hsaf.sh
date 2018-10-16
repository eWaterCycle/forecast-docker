#!/bin/bash

# eWaterCycle download script for soil moisture observations.
#
# uses environment variables:
#     ISO_DATE, for date to download
#     CREDENTIALS, for username:password for the hsaf site
#     IO_DIR, for location of shared state files for this cycle

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

#download bz2 file
wget --user ${USER} --password ${PASSWORD} ftp://ftphsaf.meteoam.it/h14/h14_cur_mon_grib/h14_${ISO_DATE}_0000.grib.bz2

