#!/usr/bin/env sh

Hostname=`echo $HOSTNAME | awk -F. '{print $1}'`
JobId=$(sacct -N ${Hostname} --format=jobid --state R --user ${USER} | sort | head -n3 | tail -n1)

re='^[0-9]+$'
if ! [[ $JobId =~ $re ]] ; then
    MODEL_HOSTS=""
else
    Host=`scontrol show job $JobId | grep ' NodeList' | awk -F'=' '{print $2}'`
    MODEL_HOSTS=`scontrol show hostname $Host | paste -d, -s`
fi
export MODEL_HOSTS=$MODEL_HOSTS