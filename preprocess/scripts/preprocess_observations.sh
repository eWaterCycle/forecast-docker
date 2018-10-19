#!/bin/bash

# eWaterCycle preprocessing script for soil moisture observations.
#
# uses environment variables:
#     INPUT_TARBALL, for input for this cycle point
#     ISO_DATE for which date to process
#     TARGET_MASK and mask to use
#     TARGET_GRID for size of grid to resize observations to
#     OUTPUT_TARBALL_NAME for the filename of the output tarball as well as the netcdf file inside the tarball

# stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

# define alternative date format
ISO_DATE_EXT=$(date -d ${ISO_DATE} +"%Y-%m-%d")

# strip the input tarball's filename to get the base name, which we'll use later
INPUT_FILENAME=`echo ${INPUT_TARBALL} | sed -e 's/^.*\///g' | sed -e 's/\.bz2//g'`
INPUT_FILENAME_NC=`echo ${INPUT_TARBALL} | sed -e 's/^.*\///g' | sed -e 's/\.grib\.bz2/\.nc/g'`

# unzip the input tarball into temp/
mkdir temp/
bzip2 -ckd ${INPUT_TARBALL} > temp/${INPUT_FILENAME}

# convert grib to netCDF
# ncl_convert2nc uses SWIx_GDS$_SFC variable naming where x in soil layer
# it will create a netcdf file named INPUT_FILENAME_NC in the process
ncl_convert2nc temp/${INPUT_FILENAME}

# scale, set correct time, date and calender, mask unwanted observations (e.g. for which there is no model)
# we've cut this up into 2 seperate commands because it was more stable in a docker container (malloc/segfault issues)
cdo settime,00:00:00 -setdate,${ISO_DATE_EXT} -setcalendar,standard ${INPUT_FILENAME_NC} temp2.nc
cdo -f nc ifthen ${TARGET_MASK} -remapbil,${TARGET_GRID} temp2.nc ${OUTPUT_TARBALL_NAME}.nc

# tar and bzip the result into the OUTPUT_TARBALL_NAME
tar cjf ${OUTPUT_TARBALL_NAME}.tar.bz2 ${OUTPUT_TARBALL_NAME}.nc
