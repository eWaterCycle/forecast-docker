#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: fetch_spinup_forcings.sh
hints:
  DockerRequirement:
    dockerImageId: ewatercycle/ewatercycle_forecast
requirements:
  EnvVarRequirement:
    envDef:
      FORCINGS_URL: $(inputs.forcings_url)
inputs:
  forcings_url:
    type: string
    default: _default

outputs:
  forcings:
    type: File
    outputBinding:
      glob: forcings.tar.gz
