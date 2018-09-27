#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: create_openda_config.py
hints:
  DockerRequirement:
    dockerImageId: rvanharen:ewtrcyclforecast
requirements:
  EnvVarRequirement:
    envDef:
      STARTTIME: $(inputs.starttime)
      ENDTIME: $(inputs.endtime)
      ENSEMBLE_MEMBER_COUNT: $(inputs.ensemble_member_count)
      STATE_WRITE_TIME: $(inputs.state_write_time)
      MODEL_HOSTS: $(inputs.model_hosts)
inputs:
  starttime:
    type: string
  endtime:
    type: string
  ensemble_member_count:
    type: int
  state_write_time:
    type: string
  model_hosts:
    type: string
outputs:
  PCRGlobWB_ModelFactoryConfig:
    type: File
    outputBinding:
      glob: openda_config/PCRGlobWB_ModelFactoryConfig.xml
  bbStochModelConfig:
    type: File
    outputBinding:
      glob: openda_config/bbStochModelConfig.xml
  enkfSequentialAlgorithmConfig:
    type: File
    outputBinding:
      glob: openda_config/enkfSequentialAlgorithmConfig.xml
  ewatercycle.oda:
    type: File
    outputBinding:
      glob: openda_config/ewatercycle.oda
  stochObserverConfig:
    type: File
    outputBinding:
      glob: openda_config/stochObserverConfig.xml
  stochObserverUncertaintiesConfig:
    type: File
    outputBinding:
      glob: openda_config/stochObserverUncertaintiesConfig.xml
  threadStochModelConfig:
    type: File
    outputBinding:
      glob: openda_config/threadStochModelConfig.xml
