# Download forecast forcings

## Instructions

Run CWL to download forcings (example):
```
cwl-runner ./forecast-docker/getforcing/cwl/download_hsaf.cwl --hsaf_passwd HSAF_PASSWD --hsaf_user HSAF_USER --iso_date 20181017
cwl-runner ./forecast-docker/getforcing/cwl/download_gfs.cwl --iso_date 20181017 
cwl-runner ./forecast-docker/getforcing/cwl/download_gefs.cwl --iso_date 20181017
```
The output of the three steps is three files:
* Observation output: h14_${iso_date}_0000.grib.bz2
* Deterministic output: gfs_${iso_date}.tar.bz2
* Ensemble output: gefs_${iso_date}.tar.bz2

These files are the input of the preprocessing steps.

## hsaf username and password

A hsaf username and password can be obtained from [H-SAF](http://hsaf.meteoam.it)
