#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: run_create_openda_config.sh
hints:
  DockerRequirement:
    dockerImageId: ewatercycle/ewatercycle_forecast
requirements:
  EnvVarRequirement:
    envDef:
      ENSEMBLE_MEMBER_COUNT: $(inputs.ensemble_member_count)
      STATE_WRITE_TIME: $(inputs.state_write_time)0000
      MODEL_HOSTS: $(inputs.model_hosts)
inputs:
  ensemble_member_count:
    type: int
  state_write_time:
    type: string
  model_hosts:
    type: string
    default: _default

outputs:
  PCRGlobWB_ModelFactoryConfig:
    type: File
    outputBinding:
      glob: openda_config.tar.gz
