# Forecast preprocessing

## Instructions

Example observations preprocessing cwl command:
```
cwl-runner cwl/preprocess_observations.cwl --input_tarball h14_20181014_0000.grib.bz2 --iso_date 20181014 --target_grid grids/30min.grid.txt --target_mask grids/30min.grid.model.mask.nc
```

Deterministic forcing preprocessing cwl command:
```
cwl-runner cwl/preprocess_deterministic_forcing.cwl --input_tarball gfs_20181014.tar.bz2
```

Ensemble forcing preprocessing cwl command:
```
cwl-runner cwl/preprocess_ensemble_forcing.cwl --input_tarball gefs_20181014.tar.bz2 --deterministic_forcing_output_tarball output_deterministic_forcing.tar.bz2 --target_grid grids/30min.grid.txtf
```
