# Build docker
`docker-compose up --build`

# Observations preprocessing cwl command:
`cwl-runner cwl/preprocess_observations.cwl --input_tarball ../data/h14_20181014_0000.grib.bz2 --iso_date 20181014`

# Deterministic forcing preprocessing cwl command:
`cwl-runner cwl/preprocess_deterministic_forcing.cwl --input_tarball ../data/gfs_20181014.tar.bz2`

# Ensemble forcing preprocessing cwl command:
`cwl-runner cwl/preprocess_ensemble_forcing.cwl --input_ensemble_tarball ../data/gefs_20181014.tar.bz2
