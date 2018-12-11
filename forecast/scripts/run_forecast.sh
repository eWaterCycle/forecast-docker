#!/bin/bash

# eWaterCycle forecast running script
# Copies all needed files into the workdir of this job, then calls openda

# stop the script if we use an unset variable, or a command fails
set -o nounset -o errexit

# copy openda config to current working directory
tar xf ${OPENDA_CONFIG}

# copy observations to openda config folder
tar xf ${OBSERVATION}

OBS=$(basename "${OBSERVATION}" | cut -d. -f1)
mv ${OBS}.nc openda_config/h14_observations.nc

# copy model
cp -r ${PCRGLOBWB_MODEL_DIR} PCR-GLOBWB

# needed for openda
mkdir model_template

cp ${PCRGLOBWB_CONFIG} model_template

find

echo ensemble_count: ${ENSEMBLE_MEMBER_COUNT}

tar xvf ${INPUT_STATE}
tar xvf ${ENSEMBLE_FORCING}

tar xvf ${HYDROWORLD} -C /tmp

# As this for loop runs up to _and_including_ the given value, we
# Get an additional member (0) for the main OpenDA model
for ensembleMember in $(seq 0 $ENSEMBLE_MEMBER_COUNT)
do
    #also create a padded version of the number
    printf -v ensembleMemberPadded '%02d' ${ensembleMember}

    INSTANCE_DIR=work${ensembleMember}
    mkdir ${INSTANCE_DIR}

    # copy config to instance
    cp ${PCRGLOBWB_CONFIG} ${INSTANCE_DIR}

    # copy initial state to instance
    ENSEMBLE_INITIAL_DIR="state/state-member${ensembleMemberPadded}"
    cp -Lr ${ENSEMBLE_INITIAL_DIR} ${INSTANCE_DIR}/initial

    # copy forcings to instance
    PRECIPITATION_FILE=precipEnsMem${ensembleMemberPadded}.nc
    TEMPERATURE_FILE=tempEnsMem${ensembleMemberPadded}.nc

    # Ensemble member 0 (the main model in OpenDA terms) does not need its own forcings as it is not actually run.
    # Borrow forcing files from member 01 so the model does not complain about lack of forcing files
    if [[ "${ensembleMember}" -eq "0" ]]
    then
        PRECIPITATION_FILE=precipEnsMem01.nc
        TEMPERATURE_FILE=tempEnsMem01.nc
    fi


    cp ${PRECIPITATION_FILE} ${INSTANCE_DIR}/precipitation.nc
    cp ${TEMPERATURE_FILE} ${INSTANCE_DIR}/temperature.nc
done

# remember workdir
WORKDIR=$PWD

# set openda variables (as per install instructions)
export OPENDADIR=${OPENDA_DIR}/bin
export PATH=${OPENDADIR}:${PATH}
export OPENDA_NATIVE=linux64_gnu
export OPENDALIB=${OPENDADIR}/${OPENDA_NATIVE}/lib

# Workdir needs to be openda bin dir for OpenDA to work properly
cd $OPENDADIR

# We use a modified version of oda_run that:
#   - Has "set -o errexit" defined to make sure cylc gets passed any error status
#   - Prints to the console instead of to a logfile
#   - Does not set LD_LIBRARY_PATH (causing conflics as it contains a lot of basic libraries such as sqlite and netcdf)
#   - Sets java.library.path to still have native libraries available to OpenDA
echo "oda_run_console.sh ${WORKDIR}/openda_config/ewatercycle.oda"
oda_run_console.sh ${WORKDIR}/openda_config/ewatercycle.oda


# restore original workdir
cd $WORKDIR


# copy output to shared dir for further processing
OUTPUT_DIR=forecast

# make sure we get a clean output dir
rm -rf ${OUTPUT_DIR}
mkdir ${OUTPUT_DIR}

for ensembleMember in $(seq 0 $ENSEMBLE_MEMBER_COUNT)
do

    # also create a padded version of the number
    printf -v ensembleMemberPadded '%02d' $ensembleMember

    if [[ "$ensembleMember" -ne "0" ]]
    then
        # copy result. Do not copy result of member 0 as it produces no valid output
        cp work${ensembleMember}/output/netcdf/discharge_dailyTot_output.nc $OUTPUT_DIR/member${ensembleMemberPadded}-discharge_dailyTot_output.nc
    fi

    OUT_STATE_DIR=output_state/state/state-member${ensembleMemberPadded}/
    mkdir -p $OUT_STATE_DIR

    cp work${ensembleMember}/output_state/* $OUT_STATE_DIR

done

tar cjf forecast.tar.bz2 forecast
tar cjf output_state.tar.bz2 -C output_state state
