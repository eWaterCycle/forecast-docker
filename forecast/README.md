# Forecast configuration and run #

## Instructions ##

Build docker as usual:
```
docker-compose build
```

Run CWL to configure:
```
cwl-runner ./forecast-docker/forecast/cwl/create_openda_config.cwl \
  --ensemble_member_count 2 --model_hosts <hostname> --state_write_time 20181016
cwl-runner ./forecast-docker/forecast/cwl/create_pcrglobwb_config.cwl \
  --starttime 20181016 --endtime 20181018 
```

```--model-hosts``` must be "" or omitted for local runs (remote not tested yet).

To run:

```
cwl-runner ./forecast-docker/forecast/cwl/run_forecast.cwl \
  --openda_config openda_config.tar.gz \
  --pcrglobwb_config pcrglobwb_config.ini \
  --observation output_observation.tar.bz2 \
  --ensemble_count 2 --input_state state.tar.gz \
  --ensemble_forcing ./output_ensemble.tar.bz2 \
  --hydroworld ./hydroworld.tar.gz
```
openda_config.tar.gz and pcrglobwb_config.ini are outputs from the above configuration CWLs. 
output_observation.tar.bz2 and output_ensemble.tar.bz2 are outputs from the preprocess steps. state.tar.gz contains
a set of model states and hydroworld.tar.gz the state independent input model data. produces forecast.tar.gz and output_state.tar.gz, which are the forecast and the model state (to serve as input for the next prediction).

## caveats ##

Need to check that the correct state is written and copied (ie the state_write_time). the input dates and times need to be checked and their internal use. Document which meteo forecast and observational data needs to be downloaded and preprocessed. Maybe change the input starttime+endtime+state_write_time to starttime+forecast period+state_write_offset. Fix defaults for forecast period and state write offset? Maybe tag the output file names with corresponding dates.
