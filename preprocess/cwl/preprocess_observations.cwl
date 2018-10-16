#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: preprocess_observations.sh
hints:
  DockerRequirement:
    dockerImageId: ewtrcycl:ewtrcyclforecast_preprocess
requirements:
  EnvVarRequirement:
    envDef:
      ISO_DATE: $(inputs.iso_date)
      OBSERVATION_MASK: $(inputs.observation_mask.basename)
      OBSERVATION_TARGET_GRID: $(inputs.target_grid.basename)
      OBSERVATIONS: $(inputs.observations.basename)
inputs:
  iso_date:
    type: int
  observation_mask:
    type: File
  target_grid:
    type: File
  observations:
    type: File
outputs:
  preprocess_observations:
    type: File
    outputBinding:
      glob: h14_$(iso_date).nc
