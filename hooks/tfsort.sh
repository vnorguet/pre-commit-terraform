#!/usr/bin/env bash
set -eo pipefail

# globals variables
# shellcheck disable=SC2155 # No way to assign to readonly variable in separate lines
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=_common.sh
. "$SCRIPT_DIR/_common.sh"

function main {
  common::initialize "$SCRIPT_DIR"
  common::parse_cmdline "$@"
  common::export_provided_env_vars "${ENV_VARS[@]}"
  common::parse_and_export_env_vars

  tfsort_ "${HOOK_CONFIG[*]}" "${ARGS[*]}" "${FILES[@]}"
  return $?
}

function tfsort_ {
  local exit_code=0

  for target_file in "${FILES[@]}"; do
    echo "Running tfsort on ${target_file}"
    tfsort "${target_file}"
    exit_code=$?
    # Return immediately if tfsort fails
    [[ "${exit_code}" -ne "0" ]] && return ${exit_code};
  done
  return 0;
}

[ "${BASH_SOURCE[0]}" != "$0" ] || main "$@"
