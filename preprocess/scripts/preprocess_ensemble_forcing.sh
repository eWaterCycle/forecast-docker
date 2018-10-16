#!/bin/bash

# eWaterCycle preprocessing script for gefs ensemble forcing
#
# uses environment variables:
#     IO_DIR, for input and output directory for this cycle point
#     ISO_DATE and ISO_DATE_EXT, for date to process
#     MODEL_GRID for definition of grid to resize forcings to, so that it is equal to the model grid

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

#copy input from shared input/output dir
cp $IO_DIR/download/gefs/* .
cp $IO_DIR/preprocess/deterministic/* .

#Select precipication and temperature variables from the downloaded input.
for ensembleMember in {01..20}
do
    #Note we skip the first file for precip
    #Since precip is only available after every 6 hours
    for hour in 06 {12..192..6};
    do
        cdo selparam,8.1.0 gep${ensembleMember}.t00z.pgrb2f${hour} precipEnsMem${ensembleMember}f${hour}.grib2
    done

    for hour in 00 06 {12..192..6};
    do
        cdo selparam,0.0.0 gep${ensembleMember}.t00z.pgrb2f${hour} tempEnsMem${ensembleMember}f{$hour}.grib2
    done

    # All downloaded files only contain one time-step.
    # Merge both precipitation and temperature files into one large file each for this ensemble member
    cdo mergetime precipEnsMem${ensembleMember}f*.grib2 precipEnsMem${ensembleMember}.grib2
    cdo mergetime tempEnsMem${ensembleMember}f*.grib2 tempEnsMem${ensembleMember}.grib2

done

#calculate the ensmeble mean for both temperature and precipitation
cdo ensmean precipEnsMem??.grib2 precipEnsMeanOut.grib2
cdo ensmean tempEnsMem??.grib2 tempEnsMeanOut.grib2

#for each ensemble member, calculate diff from mean, upscale to high res and add 
#for details on operations done see the deterministic preprocessing script
#finally, the files are interpolated (re-mapped) to the resolution of {MODEL_GRID_MASK},
#which is of the resolution of the model.

for ensembleMember in {01..20}
do
    cdo -f nc setrtoc,-100,0.0,0.0 -add forcingPrecipDailyOut.nc -remapnn,forcingPrecipDailyOut.nc -setmissval,1.0E20 -setname,precipitation -daysum -settime,00:00:00 -mulc,0.001 -sub precipEnsMem${ensembleMember}.grib2 precipEnsMeanOut.grib2 GFSResPrecipEnsMem${ensembleMember}.nc

    cdo -f nc remapbil,${MODEL_GRID} GFSResPrecipEnsMem${ensembleMember}.nc precipEnsMem${ensembleMember}.nc

    cdo -f nc add forcingTempDailyOut.nc -remapnn,forcingTempDailyOut.nc -setmissval,1.0E20 -setname,temperature -settime,00:00:00 -setunit,C -dayavg -sub tempEnsMem${ensembleMember}.grib2 tempEnsMeanOut.grib2 GFSResTempEnsMem${ensembleMember}.nc

    cdo -f nc remapbil,${MODEL_GRID} GFSResTempEnsMem${ensembleMember}.nc tempEnsMem${ensembleMember}.nc

done

# copy output to shared folder
mkdir -p $IO_DIR/preprocess/ensemble
cp tempEnsMem??.nc $IO_DIR/preprocess/ensemble/
cp precipEnsMem??.nc $IO_DIR/preprocess/ensemble/
