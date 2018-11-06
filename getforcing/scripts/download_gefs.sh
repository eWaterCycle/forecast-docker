#!/bin/bash
# script to download 0.5 degree precip and temperature data from NOAA for use as forcing for
# eWaterCycle-PCRGlobWB model
#
# assumed packages/functions: wget

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

url="http://nomads.ncep.noaa.gov/cgi-bin/filter_gens.pl"
common_parameters="lev_surface=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&var_APCP=on&var_TMP=on&dir=%2Fgefs.${ISO_DATE}%2F00%2Fpgrb2"

#make sure file does not exist, as we append to it
rm -f urls.txt

for ensembleMember in {01..20}
do
    #create url for each hour of forecast result
    #odd range definition due to odd zero-padding (not 006, but 06)
    for hour in 00 06 {12..192..6}
    do
        echo "${url}?${common_parameters}&file=gep${ensembleMember}.t00z.pgrb2f${hour}" >> urls.txt
    done
done

#single wget command to download all the urls
wget --continue --content-disposition --trust-server-names -i urls.txt

tar cvjf gefs_${ISO_DATE}.tar.bz2 gep??.t00z.pgrb2f*
