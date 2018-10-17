# Build docker
`docker-compose up --build`

# Observations preprocessing cwl command:
`cwl-runner cwl/preprocess_observations.cwl --input_tarball ../data/h14_20181014_0000.grib.bz2 --iso_date 20181014 --target_mask ../grids/30min.grid.model.mask.nc --target_grid ../grids/30min.grid.txt --output_tarball_name output_observation`

# Deterministic forcing preprocessing cwl command:
`cwl-runner cwl/preprocess_deterministic_forcing.cwl --input_tarball ../data/gfs_20181014.tar.bz2 --output_tarball_name deterministic_output_tarball`

# Ensemble forcing preprocessing cwl command:
`cwl-runner cwl/preprocess_ensemble_forcing.cwl --input_ensemble_tarball ../data/gefs_20181014.tar.bz2 --deterministic_output_tarball output_deterministic.tar.bz2 --target_grid ../grids/30min.grid.txt --output_tarball_name output_ensemble`
