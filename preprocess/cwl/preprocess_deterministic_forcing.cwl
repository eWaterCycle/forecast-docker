#!/usr/bin/env cwl-runner

# grib_precipitation_parameter: 8.1.0
# grib_temperature_parameter: 0.0.0
# netcdf_fillvalue: 1.0E20

cwlVersion: v1.0
class: CommandLineTool
baseCommand: preprocess_deterministic_forcing.sh
hints:
  DockerRequirement:
    dockerPull: ewatercycle/ewatercycle_forecast_preprocess
requirements:
  EnvVarRequirement:
    envDef:
      INPUT_TARBALL: $(inputs.input_tarball.path)
      GRIB_PRECIPITATION_PARAMETER: $(inputs.grib_precipitation_parameter)
      GRIB_TEMPERATURE_PARAMETER: $(inputs.grib_temperature_parameter)
      NETCDF_FILLVALUE: $(inputs.netcdf_fillvalue)
      OUTPUT_TARBALL_NAME: $(inputs.output_tarball_name)
inputs:
  input_tarball:
    type: File
  grib_precipitation_parameter:
    default: 8.1.0
    type: string
  grib_temperature_parameter:
    default: 0.0.0
    type: string
  netcdf_fillvalue:
    default: 1.0E20
    type: float
  output_tarball_name:
    default: output_deterministic_forcing
    type: string

outputs:
  preprocess_deterministic_forcing:    
    type: File
    outputBinding:
      glob: $(inputs.output_tarball_name).tar.bz2
