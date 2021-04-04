#!/bin/bash

# declare -A PRIVATE_INSTANCES
# declare -A SUBNETS

set -eo pipefail

usage() {
  echo "usage: $(basename $0)"
  echo "Environment variable AWS_PROFILE and AWS_REGION are required"
}

# Terraform path relatif à CLUSTER_PATH
TERRAFORM_TFSTATE=${HOME}/main/terraform/terraform.tfstate
INVENTORY_TEMPLATE=${HOME}/main/bin/inventory-base.json
OUTPUT_INVENTORY=hosts.yml

export FIRST_LINE=1

extract_tfstate_kakfa_instance_to_ansible_inventory_hosts() {
  jq '.resources[] | select(.type == "aws_instance")
  | .instances[].attributes
  | select(.tags.Components | contains("kafka"))
  | {
      (.tags.Name): {
        ansible_host: .public_ip,
        private_ip: .private_ip,
        broker_id: .tags.KafkaConfiguration | fromjson | .broker_id,
      }
    }' ${TERRAFORM_TFSTATE}
}

inject_ansible_kafka_hosts_json() {
  jq -c '.' \
  | while read line; do
      # C'est tout pourri mais il faut le faire
      if [ ${FIRST_LINE} -eq 1 ]; then
        FIRST_LINE=0
        echo ".kafka_broker.hosts += ${line}"
      else
        echo "| .kafka_broker.hosts += ${line}"
      fi
    done
}

extract_tfstate_zookeeper_instances_to_ansible_inventory_hosts() {
  jq '.resources[] | select(.type == "aws_instance")
  | .instances[].attributes
  | select(.tags.Components | contains("zookeeper"))
  | {
      (.tags.Name): {
        ansible_host: .public_ip,
        private_ip: .private_ip,
        zookeeper_id: .tags.ZookeeperConfiguration | fromjson | .zookeeper_id,
      }
    }' ${TERRAFORM_TFSTATE}
}

inject_ansible_zookeeper_hosts_json() {
  jq -c '.' \
  | while read line; do
      echo "| .zookeeper.hosts += ${line}"
    done
}

extract_tfstate_schemaregistry_instances_to_ansible_inventory_hosts() {
  jq '.resources[] | select(.type == "aws_instance")
  | .instances[].attributes
  | select(.tags.Components | contains("schema_registry"))
  | {
      (.tags.Name): {
        ansible_host: .public_ip,
        private_ip: .private_ip
      }
    }' ${TERRAFORM_TFSTATE}
}

inject_ansible_schemaregistry_hosts_json() {
  jq -c '.' \
  | while read line; do
      echo "| .schema_registry.hosts += ${line}"
    done
}

process_jq_template() {
  jq "$(extract_tfstate_kakfa_instance_to_ansible_inventory_hosts | inject_ansible_kafka_hosts_json \
    && extract_tfstate_zookeeper_instances_to_ansible_inventory_hosts | inject_ansible_zookeeper_hosts_json \
    && extract_tfstate_schemaregistry_instances_to_ansible_inventory_hosts | inject_ansible_schemaregistry_hosts_json)" ${INVENTORY_TEMPLATE}
}

process_jq_template | json2yaml > ${OUTPUT_INVENTORY}
