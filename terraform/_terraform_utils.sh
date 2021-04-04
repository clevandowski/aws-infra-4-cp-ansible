check_environment() {
  if [ -z "$AWS_PROFILE" ] || [ -z "$AWS_REGION" ]; then
    echo "Required environment variables:"
    echo "* AWS_PROFILE"
    echo "* AWS_REGION"
    echo "Aborting"
    exit 1
  fi
}

get_public_ip() {
  dig -4 +short myip.opendns.com @resolver1.opendns.com
}

plan_cloud_cluster() {
  terraform init
  if terraform validate; then
    terraform plan \
      -var aws_profile="$AWS_PROFILE" \
      -var aws_region="$AWS_REGION" \
      -var authorized_ip="$(get_public_ip)/32" \
      -out terraform.plan
  else
    echo "Error in terraform plan"
    return 1
  fi
}

apply_cloud_cluster() {
  if ! terraform apply -auto-approve terraform.plan; then
    echo "Error in terraform apply"
    return 1
  fi
}

destroy_cloud_cluster() {
  terraform init
  if ! terraform destroy \
    -var aws_profile="$AWS_PROFILE" \
    -var aws_region="$AWS_REGION" \
    -var authorized_ip="$(get_public_ip)/32"; then
    echo "Error in terraform destroy"
    return 1
  fi
}