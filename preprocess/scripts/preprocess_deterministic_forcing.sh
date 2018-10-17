#!/bin/bash

# eWaterCycle preprocessing script for gfs deterministic forcing
#
# uses environment variables:
#     IO_DIR, for input and output directory for this cycle point
#     ISO_DATE and ISO_DATE_EXT, for date to process

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

#copy from shared input/output dir
# cp $IO_DIR/download/gfs/* .
mkdir temp/
tar -xjf ${INPUT_TARBALL} -C temp/

#Select precipication from the downloaded input. Note we skip the first file,
# and any other file (since precip is only available after every 6 hours.
for hour in {006..240..6} {252..384..12};
do
    cdo selparam,${GRIB_PRECIPITATION_PARAMETER} temp/gfs.t00z.pgrb2.0p25.f${hour} precipf${hour}.grib2
done

## Precipitation ##

# merge all precipitation files into one large file. All downloaded files only contain one time-step.
cdo mergetime precipf*.grib2 forcingPrecipInput.grib2 

# Below is one big nested CDO call to get the file made above in the correct form for PCRGlobWB. The
# inputfile is forcingPrecipInput.grib2. The outputfile is forcingPrecipDailyOut.nc The functions 
# that are called are, in correct order
#
# mulc,0.001: multiply precipitation by 0.001 to change from kg/m2 to m/m2, assuming rho=1000;
#
# settime,00:00:00 set the time (not the date!) to midnight. Since the precip is given in 6 hour
# windows and CDO daysum (below) takes the end of the window as time-stamp, this makes sure that all
# data "falls" into the right day in the next step
#
# daysum sum the precipitation to daily sums.
# 
# setname,precipitation change the name of the first variale to precipitation. Needed because PCRGlobWB
# will call this variable when reading the resulting NetCDF file.
#
# setmissvall,1.0e20f Set the missing value to 1.0e20 (float). The file will not have any missing value
# but PCRGlobWB needs a _FillValue attribute.
#
# -f nc finally, this option makes sure that the output is written as NetCDF file
#cdo -f nc setmissval,${NETCDF_FILLVALUE} -setname,precipitation -daysum -settime,00:00:00 -setrtoc,-100,0.0,0.0 -mulc,0.001 -setunit,m.day-1  forcingPrecipInput.grib2 forcingPrecipDailyOut.nc
cdo -f nc settime,00:00:00 -setrtoc,-100,0.0,0.0 -mulc,0.001 -setunit,m.day-1 forcingPrecipInput.grib2 temp.nc
cdo -f nc setmissval,${NETCDF_FILLVALUE} -setname,precipitation -daysum temp.nc forcingPrecipDailyOut.nc

## Temperature ##

#Select temperature from the downloaded input.
for hour in {000..240..3} {252..384..12};
do
        cdo selparam,${GRIB_TEMPERATURE_PARAMETER} temp/gfs.t00z.pgrb2.0p25.f${hour} tempf${hour}.grib2
done

# merge all temperature files into one large file. All downloaded files only contain one time-step.
cdo mergetime tempf*.grib2 forcingTempInput.grib2 

# Below is one big nested CDO call to get the file made above in the correct form for PCRGlobWB. The
# inputfile is forcingTempInput.grib2. The outputfile is forcingTempDailyOut.nc The functions 
# that are called are, in correct order
#
# dayavg Average the temperature to daily averages.
# 
# settime,00:00:00 set the time (not the date!) to midnight. The dayavg function uses the latest slice as 
# timestamp. By doing this, we force the timestamp to be at midnight, which is important for PCRGlobWB
#
# setname,temperature change the name of the first variale to temperature. Needed because PCRGlobWB
# will call this variable when reading the resulting NetCDF file.
#
# setmissvall,1.0e20f Set the missing value to 1.0e20 (float). The file will not have any missing value
# but PCRGlobWB needs a _FillValue attribute.
#
# -f nc finally, this option makes sure that the output is written as NetCDF file
cdo -f nc setmissval,${NETCDF_FILLVALUE} -setname,temperature -settime,00:00:00 -dayavg forcingTempInput.grib2 forcingTempDailyOut-K.nc

#create a version with the temperature in Celcius as well
cdo -subc,273.15 -setunit,C forcingTempDailyOut-K.nc forcingTempDailyOut.nc

# copy output to shared folder
tar cjf ${OUTPUT_TARBALL_NAME}.tar.bz2 forcingPrecipDailyOut.nc forcingTempDailyOut.nc forcingTempDailyOut-K.nc
