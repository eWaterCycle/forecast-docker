#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: download_gefs.sh
hints:
  DockerRequirement:
    dockerPull: ewatercycle/ewatercycle_forecast_getforcing
requirements:
  EnvVarRequirement:
    envDef:
      ISO_DATE: $(inputs.iso_date)
      ENSEMBLE_MEMBER_COUNT: $(inputs.ensemble_member_count)
inputs:
  iso_date:
    type: int
  ensemble_member_count:
    type: int
outputs:
  download_gefs:
    type: File
    outputBinding:
      glob: gefs_$(inputs.iso_date).tar.bz2
