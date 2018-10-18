#!/bin/bash

# eWaterCycle preprocessing script for gefs ensemble forcing
#
# uses environment variables:
#     INPUT_TARBALL: for input for this cycle point
#     GRIB_PRECIPITATION_PARAMETER: the precipitation parameter to be selected from the grib input file, typically "8.1.0"
#     GRIB_TEMPERATURE_PARAMETER: the temperature parameter to be selected from the grib input file, typically "0.0.0"
#     NETCDF_FILLVALUE: the value to be used as fillvalue in the netcdf output, typically "1.0E20"
#     TARGET_GRID for size of grid to resize observations to
#     OUTPUT_TARBALL_NAME for the filename of the output tarball

# stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

# unzip the input tarball and the output of the deterministic forcing step into temp/
mkdir temp/
tar -xjf ${DETERMINISTIC_OUTPUT_TARBALL} -C temp/
tar -xjf ${INPUT_ENSEMBLE_TARBALL} -C temp/

# Select GRIB_PRECIPITATION_PARAMETER and GRIB_TEMPERATURE_PARAMETER variables from the downloaded input.
for ensembleMember in {01..20}
do
    # Note we skip the first file for precip
    # Since precip is only available after every 6 hours
    for hour in 06 {12..192..6};
    do
        cdo selparam,${GRIB_PRECIPITATION_PARAMETER} temp/gep${ensembleMember}.t00z.pgrb2f${hour} precipEnsMem${ensembleMember}f${hour}.grib2
    done

    for hour in 00 06 {12..192..6};
    do
        cdo selparam,${GRIB_TEMPERATURE_PARAMETER} temp/gep${ensembleMember}.t00z.pgrb2f${hour} tempEnsMem${ensembleMember}f{$hour}.grib2
    done

    # All downloaded files only contain one time-step.
    # Merge both precipitation and temperature files into one large file each for this ensemble member
    cdo mergetime precipEnsMem${ensembleMember}f*.grib2 precipEnsMem${ensembleMember}.grib2
    cdo mergetime tempEnsMem${ensembleMember}f*.grib2 tempEnsMem${ensembleMember}.grib2

done

# calculate the ensmeble mean for both temperature and precipitation
cdo ensmean precipEnsMem??.grib2 precipEnsMeanOut.grib2
cdo ensmean tempEnsMem??.grib2 tempEnsMeanOut.grib2

# for each ensemble member, calculate diff from mean, upscale to high res and add 
# for details on operations done see the deterministic preprocessing script
# finally, the files are interpolated (re-mapped) to the resolution of {TARGET_GRID},
# which is of the resolution of the model.

for ensembleMember in {01..20}
do
    # we've cut this cdo command up into seperate commands because it was more stable in a docker container (malloc/segfault issues)    
    cdo -f nc sub precipEnsMem${ensembleMember}.grib2 precipEnsMeanOut.grib2 temp.nc
    cdo -f nc setname,precipitation -daysum -settime,00:00:00 -mulc,0.001 temp.nc temp2.nc
    cdo -f nc remapnn,temp/forcingPrecipDailyOut.nc -setmissval,${NETCDF_FILLVALUE} temp2.nc temp3.nc
    cdo -f nc setrtoc,-100,0.0,0.0 -add temp/forcingPrecipDailyOut.nc temp3.nc GFSResPrecipEnsMem${ensembleMember}.nc    

    cdo -f nc remapbil,${TARGET_GRID} GFSResPrecipEnsMem${ensembleMember}.nc precipEnsMem${ensembleMember}.nc

    # we've cut this cdo command up into seperate commands because it was more stable in a docker container (malloc/segfault issues)    
    cdo -f nc sub tempEnsMem${ensembleMember}.grib2 tempEnsMeanOut.grib2 temp.nc
    cdo -f nc setname,temperature -settime,00:00:00 -setunit,C -dayavg temp.nc temp2.nc
    cdo -f nc add temp/forcingTempDailyOut.nc -remapnn,temp/forcingTempDailyOut.nc -setmissval,${NETCDF_FILLVALUE} temp2.nc GFSResTempEnsMem${ensembleMember}.nc

    cdo -f nc remapbil,${TARGET_GRID} GFSResTempEnsMem${ensembleMember}.nc tempEnsMem${ensembleMember}.nc
done

# tar and bzip the result into the OUTPUT_TARBALL_NAME
mkdir temp/out/
cp tempEnsMem??.nc temp/out/
cp precipEnsMem??.nc temp/out/
tar cjf ${OUTPUT_TARBALL_NAME}.tar.bz2 temp/out/*
