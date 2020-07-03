#!/bin/bash

singularity exec sidora.cli.sif /sidora.R "$@" --credentials /.credentials
