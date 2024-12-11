#!/bin/bash

set -euo pipefail

command=$1

base_dir=$(git rev-parse --show-toplevel) # Please fix if necessary
target=${PWD#"$base_dir"/}
config_path="$GITHUB_WORKSPACE/.github/workflows/tfcmt-with-terragrunt/.tfcmt.yaml"

if [ "$command" == "plan" ]; then
  tfcmt --var "target:${target}" --config "$config_path" plan --patch -- terraform "$@"
elif [ "$command" == "apply" ]; then
  tfcmt --var "target:${target}" --config "$config_path" apply -- terraform "$@"
else
  terraform "$@"
fi
