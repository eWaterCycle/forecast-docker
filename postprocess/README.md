# Forecast postprocessing #

## Instructions ##

# Build docker
`docker-compose up --build`

# Postprocess:
`cwl-runner cwl/postprocess.cwl --input_tarball ../data/model_output.tar.bz2 --uncertainty_template_file ../data/uncertaintyTemplate.nc`
