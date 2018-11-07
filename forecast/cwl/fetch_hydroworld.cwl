#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: fetch_hydroworld.sh
hints:
  DockerRequirement:
    dockerPull: ewatercycle/ewatercycle_forecast
requirements:
  EnvVarRequirement:
    envDef:
      HYDROWORLD_URL: $(inputs.hydroworld_url)
inputs:
  hydroworld_url:
    type: string
    default: _default

outputs:
  hydroworld:
    type: File
    outputBinding:
      glob: hydroworld.tar.gz
