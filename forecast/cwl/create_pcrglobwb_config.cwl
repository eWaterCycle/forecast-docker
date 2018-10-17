#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: create_pcrglobwb_config.py
hints:
  DockerRequirement:
    dockerImageId: rvanharen:ewtrcyclforecast
requirements:
  EnvVarRequirement:
    envDef:
      STARTTIME: $(inputs.starttime)
      ENDTIME: $(inputs.endtime)
      HYDROWORLD_LOCATION: $(inputs.hydroworld_location)
inputs:
  starttime:
    type: string
  endtime:
    type: string
  hydroworld_location:
    type: string
    default: '/tmp/hydroworld'
outputs:
  pcrglobwb_config:
    type: File
    outputBinding:
      glob: pcrglobwb_config.ini
