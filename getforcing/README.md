# Download forecast forcings #

## Instructions ##

Build docker as usual:
```
docker-compose build
```

Run CWL to download forcings (example):
```
cwl-runner ./forecast-docker/getforcing/cwl/download_hsaf.cwl --hsaf_passwd HSAF_PASSWD --hsaf_user HSAF_USER --iso_date 20181017
cwl-runner ./forecast-docker/getforcing/cwl/download_gfs.cwl --iso_date 20181017 
cwl-runner ./forecast-docker/getforcing/cwl/download_gefs.cwl --iso_date 20181017
```
The output of the three steps is three files:
* output_observation.tar.bz2 (in the format: h14_${iso_date}_0000.grib.bz2)
* deterministic_output_tarball.tar.bz2 (in the format: gfs_${iso_date}.tar.bz2)
* output_ensemble.tar.bz2 (in the format: gefs_${iso_date}.tar.bz2)

These files are the input of the preprocessing steps.

## hsaf username and password ##

A hsaf username and password can be obtained from [H-SAF](http://hsaf.meteoam.it])
