# Forecast configuration and run

## Instructions

Example to run CWL to configure the forecast:
```
cwl-runner ./forecast-docker/forecast/cwl/create_openda_config.cwl \
  --ensemble_member_count 2 --model_hosts <hostname> --state_write_time 20181016
cwl-runner ./forecast-docker/forecast/cwl/create_pcrglobwb_config.cwl \
  --starttime 20181016 --endtime 20181018 
```

```--model-hosts```  must be "" or omitted for local runs (remote not tested 
yet).

Fetch model of world:
```
cwl-runner ../forecast-docker/forecast/cwl/fetch_hydroworld.cwl
```

You can create an initial state by:
```
cwl-runner ./forecast-docker/forecast/cwl/fetch_spinup_forcings.cwl
cwl-runner ./forecast-docker/forecast/cwl/create_pcrglobwb_config.cwl \
  --starttime 20100101 --endtime 20100101 --spinup true --max_spinup 0
cwl-runner ./forecast-docker/forecast/cwl/run_spinup.cwl \
  --forcings forcings.tar.gz --hydroworld hydroworld.tar.gz --pcrglobwb_config pcrglobwb_config.ini
cwl-runner ./forecast-docker/forecast/cwl/clone_state.cwl \
  --input_state output_state.tar.bz2 --number_of_clones 2
```

Note the pcrglobwb_config.ini cannot be reused between spin up and forecast 
run. The max spinup (in years) can be set to 30 (for normal spinup) or zero 
to (quickly) get a zero state. Note the given starttime agrees with the 
(default) downloaded climatology. Would need to be changed accordingly for 
different forcings..

Additionally workflows to run one or more member with a deterministic 
forcing is included (useful for extra warm up step before forecast):
```
cwl-runner ./forecast-docker/forecast/cwl/create_pcrglobwb_config.cwl \
  --starttime 20100101 --endtime 20100110
cwl-runner ./forecast-docker/forecast/cwl/run_deterministic.cwl \
  --forcings forcings.tar.gz --hydroworld hydroworld.tar.gz \
  --members_to_run "0"  --input_state output_state.tar.bz2  \
  --pcrglobwb_config pcrglobwb_config.ini
```

To run forecast:

```
cwl-runner ./forecast-docker/forecast/cwl/run_forecast.cwl \
  --openda_config openda_config.tar.gz \
  --pcrglobwb_config pcrglobwb_config.ini \
  --observation output_observation.tar.bz2 \
  --ensemble_count 2 --input_state state.tar.gz \
  --ensemble_forcing ./output_ensemble.tar.bz2 \
  --hydroworld ./hydroworld.tar.gz
```

openda_config.tar.gz and pcrglobwb_config.ini are outputs from the above 
configuration CWLs. output_observation.tar.bz2 and output_ensemble.tar.bz2 
are outputs from the preprocess steps. state.tar.gz contains a set of model 
states and hydroworld.tar.gz the state independent input model data. 
produces forecast.tar.gz and output_state.tar.gz, which are the forecast 
and the model state (to serve as input for the next prediction).

## caveats

Need to check that the correct state is written and copied (ie the 
state_write_time). the input dates and times need to be checked and their 
internal use. Document which meteo forecast and observational data needs to 
be downloaded and preprocessed. Maybe change the input 
starttime+endtime+state_write_time to starttime+forecast 
period+state_write_offset. Fix defaults for forecast period and state write 
offset? Maybe tag the output file names with corresponding dates.
