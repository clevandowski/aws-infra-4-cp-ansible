#!/usr/bin/env bash

set -euo pipefail

source _terraform_utils.sh

check_environment

destroy_cloud_cluster
