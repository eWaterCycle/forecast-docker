#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: run_forecast.sh
hints:
  DockerRequirement:
    dockerImageId: rvanharen:ewtrcyclforecast
requirements:
  EnvVarRequirement:
    envDef:
      PCRGlobWB_ModelFactoryConfig: $(inputs.PCRGlobWB_ModelFactoryConfig)
      bbStochModelConfig: $(inputs.bbStochModelConfig)
      enkfSequentialAlgorithmConfig: $(inputs.enkfSequentialAlgorithmConfig)
      ewatercycle_oda: $(inputs.ewatercycle_oda)
      stochObserverConfig: $(inputs.stochObserverConfig)
      stochObserverUncertaintiesConfig: $(inputs.stochObserverUncertaintiesConfig)
      threadStochModelConfig: $(inputs.threadStochModelConfig)
      pcrgobwb_config: $(inputs.pcrgobwb_config)
      observationFile: $(inputs.observationFile)
inputs:
  PCRGlobWB_ModelFactoryConfig:
    type: File
  bbStochModelConfig:
    type: File
  enkfSequentialAlgorithmConfig:
    type: File
  ewatercycle_oda:
    type: File
  stochObserverConfig:
    type: File
  stochObserverUncertaintiesConfig:
    type: File
  threadStochModelConfig:
    type: File
  pcrgobwb_config:
    type: File
  observationFile:
    type: File
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
