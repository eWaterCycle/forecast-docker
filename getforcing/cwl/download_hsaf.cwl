#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: download_hsaf.sh
hints:
  DockerRequirement:
    dockerImageId: ewatercycle/ewatercycle_forecast_getforcing
requirements:
  EnvVarRequirement:
    envDef:
      ISO_DATE: $(inputs.iso_date)
      USER: $(inputs.hsaf_user)
      PASSWORD: $(inputs.hsaf_passwd)
inputs:
  iso_date:
    type: int
  hsaf_user:
    type: string
  hsaf_passwd:
    type: string
outputs:
  download_hsaf:
    type: File
    outputBinding:
      glob: h14_$(inputs.iso_date)_0000.grib.bz2 
