#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: download_gfs.sh
hints:
  DockerRequirement:
    dockerImageId: ewatercycle/ewatercycle_forecast_getforcing
requirements:
  EnvVarRequirement:
    envDef:
      ISO_DATE: $(inputs.iso_date)
inputs:
  iso_date:
    type: int
outputs:
  download_gfs:
    type: File
    outputBinding:
      glob: gfs_$(inputs.iso_date).tar.bz2
