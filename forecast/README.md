# Forecast configuration and run #

## Instructions ##

Build docker as usual:
```
docker-compose build
```

Run CWL to configure:
```
cwl-runner ./forecast-docker/forecast/cwl/create_openda_config.cwl --ensemble_member_count 2 --model_hosts <hostname> --state_write_time 201810160000
cwl-runner ./forecast-docker/forecast/cwl/create_pcrglobwb_config.cwl  --starttime 20181016 --endtime 20181018 
```

```--model-hosts``` can be omitted for local runs (remote not tested).

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
