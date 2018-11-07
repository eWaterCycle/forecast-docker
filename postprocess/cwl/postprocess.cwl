#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: postprocess.sh
hints:
  DockerRequirement:
    dockerPull: ewatercycle/ewatercycle_forecast_postprocess
requirements:
  EnvVarRequirement:
    envDef:
      INPUT_TARBALL: $(inputs.input_tarball.path)
      UNCERTAINTY_TEMPLATE_NC_FILE: $(inputs.uncertainty_template_file.path)
      OUTPUT_TARBALL_NAME: $(inputs.output_tarball_name)
inputs:
  input_tarball:
    type: File
  uncertainty_template_file:
    type: File
  output_tarball_name:
    default: output_postprocessing
    type: string

outputs:
  postprocess:    
    type: File
    outputBinding:
      glob: $(inputs.output_tarball_name).tar.bz2
