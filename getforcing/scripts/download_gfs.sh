#!/bin/bash
# script to download 0.5 degree precip and temperature data from NOAA for use as forcing for
# eWaterCycle-PCRGlobWB model
#
# assumed packages/functions: wget

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

url="http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl"
common_parameters="lev_surface=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&var_APCP=on&var_TMP=on&dir=%2Fgfs.${ISO_DATE}00"

rm -f urls.txt

for hour in {000..240..3} {252..384..12};
do
    echo "${url}?${common_parameters}&file=gfs.t00z.pgrb2.0p25.f${hour}" >> urls.txt
done


#single wget command to download all the urls
wget --continue --content-disposition --trust-server-names -i urls.txt

tar cvjf gfs_${ISO_DATE}.tar.bz2 gfs.t00z.pgrb2.0p25.*
