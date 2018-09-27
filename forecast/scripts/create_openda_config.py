#!/usr/bin/env python

import os
import sys
import shutil
from jinja2 import Environment, FileSystemLoader

# Generate OpenDA configuration by doing a simple search-and-replace on a configuration template.
# Uses jinja 2 for processing


if __name__ == '__main__':

    # FIXME hardcode template dir for 30min
    #openda_config_template_dir = os.getenv('OPENDA_CONFIG_TEMPLATE_DIR')
    openda_config_template_dir = '/usr/src/templates/openda/template_30min'

    if openda_config_template_dir is None:
        print "ERROR: configuration template dir not defined"
        sys.exit(1)

    if not os.path.isdir(openda_config_template_dir):
        print "ERROR: configuration template dir (%s) does not exist" % openda_config_template_dir
        sys.exit(1)

    io_dir = os.getenv("IO_DIR")

    if not os.path.isdir(io_dir):
        print "IO dir does not exist"
        exit(1)

    result_dir = 'openda_config'
    os.mkdir(result_dir)

    #dict with all replacements
    replacements = {
        'starttime': os.getenv('STARTTIME'),
        'endtime':os.getenv('ENDTIME'),
        'ensemble_member_count': os.getenv('ENSEMBLE_MEMBER_COUNT'),
        'state_write_time': os.getenv('STATE_WRITE_TIME'),
        'model_hosts': os.getenv('MODEL_HOSTS'),
    }

    #jinja2 environment
    environment = Environment(loader=FileSystemLoader(openda_config_template_dir))

    for template_name in environment.list_templates():
        result_filename = os.path.join(result_dir, template_name)

        print "creating config file %s from template %s" % (result_filename, template_name)

        result_string = environment.get_template(template_name).render(replacements)

        #write to a file

        result_file = open(result_filename, 'w')
        result_file.write(result_string)
        result_file.close()

    io_output_dir = os.path.join(io_dir, 'forecast', result_dir)

    if os.path.isdir(io_output_dir):
        shutil.rmtree(io_output_dir)

    shutil.copytree(result_dir, io_output_dir)
