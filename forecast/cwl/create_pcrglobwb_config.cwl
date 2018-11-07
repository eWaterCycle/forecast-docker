#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: run_create_pcrglobwb_config.sh
hints:
  DockerRequirement:
    dockerImageId: ewatercycle/ewatercycle_forecast
requirements:
  EnvVarRequirement:
    envDef:
      STARTTIME: $(inputs.starttime)
      ENDTIME: $(inputs.endtime)
      HYDROWORLD_LOCATION: $(inputs.hydroworld_location)
      PCRGLOBWB_CONFIG_TEMPLATE: $(inputs.config_template)
      ZERO_STATE: $(inputs.zerostate)
inputs:
  starttime:
    type: string
  endtime:
    type: string
  hydroworld_location:
    type: string
    default: '/tmp/hydroworld'
  config_template:
    type: string
    default: 'template-30min.ini'
  zerostate:
    type: string
    default: no
outputs:
  pcrglobwb_config:
    type: File
    outputBinding:
      glob: pcrglobwb_config.ini
