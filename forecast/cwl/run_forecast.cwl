#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: run_forecast.sh
hints:
  DockerRequirement:
    dockerPull: ewatercycle/ewatercycle_forecast
requirements:
  EnvVarRequirement:
    envDef:
      OBSERVATION: $(inputs.observation.path)
      OPENDA_CONFIG: $(inputs.openda_config.path)
      PCRGLOBWB_CONFIG: $(inputs.pcrglobwb_config.path)
      ENSEMBLE_MEMBER_COUNT: $(inputs.ensemble_count)
      INPUT_STATE: $(inputs.input_state.path)
      ENSEMBLE_FORCING: $(inputs.ensemble_forcing.path)
      HYDROWORLD: $(inputs.hydroworld.path)      
inputs:
  openda_config:
    type: File
  pcrglobwb_config:
    type: File
  observation:
    type: File
  ensemble_count:
    type: int
  input_state:
    type: File
  ensemble_forcing:
    type: File
  hydroworld:
    type: File

outputs:
  forecast:
    type: File
    outputBinding:
      glob: forecast.tar.gz
  new_state:
    type: File
    outputBinding:
      glob: output_state.tar.gz
