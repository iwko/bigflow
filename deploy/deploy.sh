#!/bin/bash
set -e

[ -d ".image" ] && image_dir=".image" || image_dir="image"
[ -d ".dags" ] && dags_dir=".dags" || dags_dir="dags"

bf_version=`cat "$image_dir/bigflow_version.txt"` || bf_version=1.0.0
workflow_id=`cat "$dags_dir/workflow_id.txt" || echo ""`

pip install bigflow==$bf_version

image_name=`ls "$image_dir" | sort -r | head -n 1`

echo "len of bamboo_bf_vault_secret is ${#1}, should be ~ 26"
bamboo_bf_vault_secret=$1

deploy_args=()
if test -z "$workflow_id" || test "$workflow_id" = "ALL"
then
    # Clear dags folder only when all workflows are going to be deployed.
    # TODO(CHIBOX-893): Also delete single workflow when `bigflow` will provide support for it.
    echo "Clear dags folder"
    deploy_args+=("--clear-dags-folder")
else
    echo "Deploy only $workflow_id"
fi

bf deploy \
    --image-tar-path "$image_dir/$image_name" \
    --deployment-config-path "$image_dir/deployment_config.py" \
    --auth-method vault \
    --vault-secret "$1" \
    "${deploy_args[@]}"
