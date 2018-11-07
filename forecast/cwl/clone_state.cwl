#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: clone_state.sh
hints:
  DockerRequirement:
    dockerImageId: ewatercycle/ewatercycle_forecast
requirements:
  EnvVarRequirement:
    envDef:
      INPUT_STATE: $(inputs.input_state.path)
      NCLONES: $(inputs.number_of_clones)
      ORG: $(inputs.src_clone)
inputs:
  input_state:
    type: File
  src_clone:
    type: int
    default: "0"
  number_of_clones:
    type: int
    default: 20

outputs:
  new_state:
    type: File
    outputBinding:
      glob: output_state.tar.bz2
