#!/bin/bash
set -e

time docker build -t bgh-strafrecht:4.4.0 .

time docker-compose run --rm bgh-strafrecht Rscript delete_all_data.R
