#!/bin/bash

# install psql for WMS database script
apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# install ruamel for yaml parsing
pip3 install \
    ruamel.yaml \
    && rm -rf $HOME/.cache/pip

# Init system
datacube system init --no-init-users 2>&1

# Add Products @TODO: Make this a variable
datacube product add ../prod/products/nrt/landsat/products.yaml
datacube product add ../prod/products/nrt/sentinel/products.yaml

# Generate WMS specific config
PGPASSWORD=$DB_PASSWORD psql \
    -d $DB_DATABASE \
    -h $DB_HOSTNAME \
    -p $DB_PORT \
    -U $DB_USERNAME \
    -f create_tables.sql 2>&1

# Run index
./update_ranges_wrapper.sh