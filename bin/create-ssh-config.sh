#!/bin/bash

declare -A INSTANCES
declare -A SUBNETS

set -eo pipefail

usage() {
  echo "usage: $(basename $0)"
}

# Terraform path relatif à CLUSTER_PATH
TERRAFORM_TFSTATE=${HOME}/main/terraform/terraform.tfstate

getHostsIps() {
  local AWS_INSTANCES=$(
    jq '.resources[] | select(.type == "aws_instance") | .instances[].attributes
      | { (.tags.Name): (.public_ip) }' ${TERRAFORM_TFSTATE} \
    | grep ":" | tr -d '" '
  )
  for instance in ${AWS_INSTANCES[@]}; do
    local instanceName=$(echo ${instance} | cut -d : -f 1)
    local instanceIp=$(echo ${instance} | cut -d : -f 2)
    INSTANCES[${instanceName}]=${instanceIp}
  done
}

createSshConfig() {
  if [ -f ssh_config ]; then
    rm ssh_config
  fi

  ID_RSA_FILE="${HOME}/.ssh/id_rsa"
  if [ ! -f ${ID_RSA_FILE} ]; then
    echo "[ERROR] ssh key ${ID_RSA_FILE} does not exists or is not readable"
  fi

  getHostsIps
  # Création de la configuration pour chacun des hosts 
  for hName in "${!INSTANCES[@]}"; do
    prefix=$(echo ${hName} | sed -e 's|^\([^_]\+\)_.*$|\1|')
    
    if [ "${prefix}" == "bastion" ]; then
      cat << EOF >> ssh_config

Host $hName
  Hostname ${INSTANCES[$hName]}
  User ubuntu
  IdentityFile ${ID_RSA_FILE}
  StrictHostKeyChecking no
EOF
    else
      cat << EOF >> ssh_config

Host $hName
  Hostname ${INSTANCES[$hName]}
  User centos
  IdentityFile ${ID_RSA_FILE}
  StrictHostKeyChecking no
EOF
    fi
  done
}

createSshConfig
