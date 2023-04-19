#!/bin/bash
set -e

time docker build -t bgh-strafrecht:4.2.2 .

time docker-compose run --rm bgh-strafrecht Rscript run_project.R
