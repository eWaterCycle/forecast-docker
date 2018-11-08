#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: run_spinup.sh
hints:
  DockerRequirement:
    dockerPull: ewatercycle/ewatercycle_forecast
requirements:
  EnvVarRequirement:
    envDef:
      FORCINGS: $(inputs.forcings.path)
      PCRGLOBWB_CONFIG: $(inputs.pcrglobwb_config.path)
      HYDROWORLD: $(inputs.hydroworld.path)      
inputs:
  pcrglobwb_config:
    type: File
  forcings:
    type: File
  hydroworld:
    type: File

outputs:
  new_state:
    type: File
    outputBinding:
      glob: output_state.tar.bz2
