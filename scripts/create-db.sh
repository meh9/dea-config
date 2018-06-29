#!/bin/bash

# Convert vars to TF specific ones
export TF_VAR_db_hostname=$DB_HOSTNAME
export TF_VAR_database=$DB_DATABASE
export TF_VAR_db_username=$DB_USERNAME
export TF_VAR_db_password=$DB_PASSWORD
export TF_VAR_admin_username=$ADMIN_USERNAME
export TF_VAR_admin_password=$ADMIN_PASSWORD


# install postgres
apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client awscli curl jq\
    && rm -rf /var/lib/apt/lists/*

# install terraform
curl -o terraform.zip $(echo "https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')_linux_amd64.zip")
unzip terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
    terraform -v 

# build database
cd setup

terraform init -backend-config="bucket=$STATE_BUCKET" -backend-config="key=$DB_DATABASE.tfstate" && terraform apply -auto-approve