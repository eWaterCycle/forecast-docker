#!/bin/bash

# eWaterCycle preprocessing script for soil moisture observations.
#
# uses environment variables:
#     IO_DIR, for input and output directory for this cycle point
#     ISO_DATE and ISO_DATE_EXT, for date to process
#     MODEL_GRID_MASK for size of grid to resize observations to, and mask to use (no need for observations at point for which there is no model (e.g. oceans)
#          note that MODEL_GRID_MASK in this script does not need to point to the same mask as in the preprocess_deterministic_forcing.sh script.

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

# define alternative date format
ISO_DATE_EXT=$(date -d ${ISO_DATE} +"%Y-%m-%d")

INPUT_FILENAME=`echo ${INPUT_TARBALL} | sed -e 's/^.*\///g' | sed -e 's/\.bz2//g'`
INPUT_FILENAME2=`echo ${INPUT_TARBALL} | sed -e 's/^.*\///g' | sed -e 's/\.grib\.bz2/\.nc/g'`

#unzip
mkdir temp/
bzip2 -ckd ${INPUT_TARBALL} > temp/${INPUT_FILENAME}

# convert grib to netCDF
# ncl_convert2nc uses SWIx_GDS$_SFC variable naming where x in soil layer
ncl_convert2nc temp/${INPUT_FILENAME}

#scale, set correct time, date and calender, mask unwanted observations (e.g. for which there is no model)
cdo settime,00:00:00 -setdate,${ISO_DATE_EXT} -setcalendar,standard ${INPUT_FILENAME2} temp2.nc
cdo -f nc ifthen ${TARGET_MASK} -remapbil,${TARGET_GRID} temp2.nc ${OUTPUT_TARBALL_NAME}.nc

# tar
tar cjf ${OUTPUT_TARBALL_NAME}.tar.bz2 ${OUTPUT_TARBALL_NAME}.nc
