#!/bin/bash

set -euo pipefail

# --- Configuration Variables ---
export cluster_name=""
export region="eu-west-2"
export version="1.34"
export profile=""
export nodegroups=(
  "backend-large"
  "backend-medium"
)

# --- Logging Functions ---
log() {
  echo -e "\033[1;32m[$(date '+%Y-%m-%d %H:%M:%S')]\033[0m $1"
}

error() {
  echo -e "\033[1;31m[$(date '+%Y-%m-%d %H:%M:%S') ERROR]\033[0m $1" >&2
}

# --- User Confirmation ---
echo "Please confirm the following configuration:"
echo "-------------------------------------------"
echo "Cluster Name    : $cluster_name"
echo "AWS Region      : $region"
echo "K8s Version     : $version"
echo "AWS CLI Profile : $profile"
echo "NodeGroups      : ${nodegroups[*]}"
echo "-------------------------------------------"
read -rp "Proceed with upgrade? (yes/no): " confirm

if [[ "$confirm" != "yes" ]]; then
  error "Aborted by user."
  exit 1
fi

# --- Start Cluster Upgrade ---
log "Starting upgrade of EKS cluster: $cluster_name"

log "Upgrading EKS cluster..."
if eksctl upgrade cluster --name="$cluster_name" --region="$region" --profile="$profile" --version="$version" --approve; then
  log "✅ Master node upgrade completed"
else
  error "❌ Master Node upgrade failed!"
  exit 1
fi

# --- NodeGroup Upgrades ---
log "Starting NodeGroup upgrades..."

declare -A job_status

for nodegroup_name in "${nodegroups[@]}"; do
  {
    log "Upgrading NodeGroup: $nodegroup_name"
    if eksctl upgrade nodegroup --name="$nodegroup_name" --cluster="$cluster_name" --kubernetes-version="$version" --region="$region" --profile="$profile"; then
      log "✅ NodeGroup $nodegroup_name upgraded successfully"
      job_status["$nodegroup_name"]="success"
    else
      error "❌ Failed to upgrade NodeGroup: $nodegroup_name"
      job_status["$nodegroup_name"]="failed"
    fi
  } &
done

wait

log "NodeGroup upgrade summary:"
for nodegroup_name in "${!job_status[@]}"; do
  status=${job_status["$nodegroup_name"]}
  if [[ "$status" == "success" ]]; then
    echo -e "  ✅ $nodegroup_name upgrade: \033[1;32mSUCCESS\033[0m"
  else
    echo -e "  ❌ $nodegroup_name upgrade: \033[1;31mFAILED\033[0m"
  fi
done

log "🎉 Cluster upgrade process completed successfully."