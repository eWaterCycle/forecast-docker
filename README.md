# forecast-docker

Runs PGRCGLOB-WB global hydrology forecast using Cylc and CWL.

# Dependencies

## Cylc

Require version 7.6.x or higher of [Cylc](https://cylc.github.io).
Follow [installation instructions](https://cylc.github.io/cylc/html/multi/cug-html.html) or run the [Ansible playbook](https://github.com/eWaterCycle/infra/tree/master/eoscpilot)

## cwl-runner

Most tasks in the Cylc workflow are written in [Common Workflow Language](https://www.commonwl.org/).
The `cwl-runner` executable should be in your path by installing the reference cwl runner with:
```bash
pip2 install cwlref-runner
```

## Docker

Most tasks run inside in a Docker container by the cwl-runner. Follow [installation instructions](https://docs.docker.com/install/) so `docker` can be run as the user.

# Steps

The forecast consists of multiple steps. In order to get the forecast running, the following steps should be executed in order.

* [Download forcings and observations](getforcing/README.md)
* [Preprocess forcings and observations](preprocess/README.md)
* [Configure and run forecast](forecast/README.md)
* [Postprocess forecast output](postprocess/README.md)
