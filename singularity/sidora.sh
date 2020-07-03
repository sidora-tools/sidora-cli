#!/bin/bash

singularity exec /projects1/clusterhomes/schmid/sidora/sidora.cli.sif /sidora.R "$@" --credentials /.credentials
