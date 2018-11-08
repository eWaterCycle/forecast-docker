#!/bin/bash

# eWaterCycle forecast running script
# Copies all needed files into the workdir of this job, then calls openda

#stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

HYDROWORLD_DIR=`awk '/inputDir =/ {print $3} ' ${PCRGLOBWB_CONFIG}`

#copy forcings to instance
PRECIPITATION_FILE=precipitation.nc4
TEMPERATURE_FILE=temperature.nc4

tar xvf ${HYDROWORLD} -C /tmp
tar xvf ${FORCINGS} -C ${HYDROWORLD_DIR}

tar xvf ${INPUT_STATE}

for ensembleMember in ${MEMBERSTORUN}
do

printf -v ensembleMemberPadded '%02d' ${ensembleMember}

INSTANCE_DIR=work${ensembleMemberPadded}

mkdir ${INSTANCE_DIR}

mkdir ${HYDROWORLD_DIR}/initial

cp state/state-member${ensembleMemberPadded}/* ${HYDROWORLD_DIR}/initial/

# copy config to instance
cp ${PCRGLOBWB_CONFIG} ${INSTANCE_DIR}

cd ${INSTANCE_DIR}


#copy model
cp -r ${PCRGLOBWB_MODEL_DIR}/model/* ./

python deterministic_runner.py ${PCRGLOBWB_CONFIG}

mkdir -p ../output_state/state/state-member${ensembleMemberPadded}

ls output/states/ |  awk '!/-/ {print "cp output/states/"$0" ../output_state/state/state-member'${ensembleMemberPadded}'/"}' | sh

cd ..

rm -rf ${HYDROWORLD_DIR}/initial

done

tar cjf output_state.tar.bz2 -C output_state state
