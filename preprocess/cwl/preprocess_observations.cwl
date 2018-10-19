#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: preprocess_observations.sh
hints:
  DockerRequirement:
    dockerImageId: ewatercycle/ewtrcycl:ewtrcyclforecast_preprocess
requirements:
  EnvVarRequirement:
    envDef:
      INPUT_TARBALL: $(inputs.input_tarball.path)
      ISO_DATE: $(inputs.iso_date)
      TARGET_MASK: $(inputs.target_mask.path)
      TARGET_GRID: $(inputs.target_grid.path)
      OUTPUT_TARBALL_NAME: $(inputs.output_tarball_name)
inputs:
  input_tarball:
    type: File
  iso_date:
    type: int
  target_mask:
    type: File
  target_grid:
    type: File
  output_tarball_name:
    default: output_observations
    type: string

outputs:
  preprocess_observations:
    type: File
    outputBinding:
      glob: $(inputs.output_tarball_name).tar.bz2
