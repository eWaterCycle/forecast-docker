#!/usr/bin/env python

import os
import sys
import shutil
from jinja2 import Environment, FileSystemLoader


# Generate PCRGlob-WB configuration by doing a simple search-and-replace on a configuration template.
# Uses jinja 2 for processing

#input template (set in environment by Cylc)
#config_template=os.getenv('PCRGLOBWB_CONFIG_TEMPLATE')
# FIXME hardcode config_template

template_dir=os.getenv('PCRGLOBWB_CONFIG_TEMPLATE_DIR')
if not template_dir:
    template_dir='/usr/src/templates/pcrglobwb/'
template_file=os.getenv('PCRGLOBWB_CONFIG_TEMPLATE')
if not template_file:
    template_file='template-30min.ini'

config_template = os.path.join(template_dir,template_file)

#dict with all replacements
replacements = {
    'hydroworld_location':os.getenv('HYDROWORLD_LOCATION'),
    'outputdir': "output",
    'starttime': os.getenv('STARTTIME'),
    'endtime':os.getenv('ENDTIME'),
    'precipitationfile':"precipitation.nc",
    'temperaturefile':"temperature.nc",
    'initial_conditions_dir':"initial"
}

environment = Environment(loader=FileSystemLoader(template_dir))

result_string = environment.get_template(template_file).render(replacements)

# print "##### START RESULTING CONFIGURATION #####"
# print result_string
# print "##### END RESULTING CONFIGURATION #####"

result_filename = 'pcrglobwb_config.ini'

# First write content to file then copy file is less efficient, but more robust,
# and leaves a copy of the output in the workdir of this job for debugging
result_file = open(result_filename, 'w')
result_file.write(result_string)
result_file.close()
