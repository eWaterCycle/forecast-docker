#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: run_deterministic.sh
hints:
  DockerRequirement:
    dockerPull: ewatercycle/ewatercycle_forecast
requirements:
  EnvVarRequirement:
    envDef:
      INPUT_STATE: $(inputs.input_state.path)
      FORCINGS: $(inputs.forcings.path)
      PCRGLOBWB_CONFIG: $(inputs.pcrglobwb_config.path)
      HYDROWORLD: $(inputs.hydroworld.path)      
      MEMBERSTORUN: $(inputs.members_to_run)
inputs:
  input_state:
    type: File
  pcrglobwb_config:
    type: File
  forcings:
    type: File
  hydroworld:
    type: File
  members_to_run:
    type: string
    default: "0"

outputs:
  new_state:
    type: File
    outputBinding:
      glob: output_state.tar.bz2
