#!/bin/bash
set -e

pip install -r resources/requirements.txt

git remote set-url origin $1
python -c 'import bamboo_build;bamboo_build.release_version_if_on_master()'
releaseVersion=$(python -c 'import bamboo_build;bamboo_build.get_bamboo_release_version()')

args_array=()

if [ -n "$2" ]; then
    args_array+=("--start-time" "$2")
fi

if [ -n "$3" ]; then
    workflow_id="$3"
    args_array+=("--workflow" "$workflow_id")
fi

echo "bf build ${args_array[@]}"
bf build "${args_array[@]}"

[ -d ".image" ] && image_dir=".image" || image_dir="image"
[ -d ".dags" ] && dags_dir=".dags" || dags_dir="dags"
pip freeze | grep '^bigflow' | sed 's/bigflow==//' > "$image_dir/bigflow_version.txt"

echo "version=$releaseVersion" > variables.txt

if [ -n "$workflow_id" ]; then
    # TODO: Remove after such logic (generate metadata about builded dags) is integrated into `bigflow`.
    echo "$workflow_id" >> $dags_dir/workflow_id.txt
fi
