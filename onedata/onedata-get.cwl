#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /opt/onedata-get.sh
arguments: [$(inputs.source), $(inputs.dest)]
hints:
  DockerRequirement:
    dockerPull: ewatercycle/oneclient
requirements:
  EnvVarRequirement:
    envDef:
      ONECLIENT_ACCESS_TOKEN: MDAxNWxvY2F00aW9uIG9uZXpvbmUKMDAzMGlkZW500aWZpZXIgMjA3NWI4NWZhZjM4OThmMTUzYmIzMGE2MDQ00NjI5NDcKMDAxYWNpZCB00aW1lIDwgMTU3MTMxMzA2MQowMDJmc2lnbmF00dXJlIIBSX02WEVzWhvWBKnGHuP6gmhosMr6Bf302gsl3NKvKV1Cg
      ONECLIENT_PROVIDER_HOST: oneprovider-cnaf.datahub.egi.eu
inputs:
  source:
    type: string
  dest:
    type: Directory
  token:
    type: string
  provider:
    type: string
outputs:
  status:
    type: stdout
