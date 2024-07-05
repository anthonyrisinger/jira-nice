#!/bin/bash

set -ef; shopt -s extglob nullglob; IFS=$'\n'

# TODO: Only search ../.jira.config when inside a parent repo.
DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
CONFIGS=($(set +f; printf '%s\n' $DIR/{,../.jira.}config/[0-9][0-9]-*))

yaml2json () { command $DIR/bin/yaml2json "$@"; }
jq () { command $DIR/bin/jq "$@"; }

scanner () {
  # Process `XX-ABC` only once and favor `XX-ABC` over `XX-ABC-default`.
  for config in "${CONFIGS[@]}"; do
    key=${config##*/}; key=${key%%.*}
    [[ ! $key =~ -sample$ ]] &&
      echo -e "$key\t$config"
  done | sort -u -s -t- -k1,1n | cut -d$'\t' -f2
}

configurables () {
  while read -r config; do
    if [[ -x $config ]]; then
      $config
    elif [[ $config =~ .yml$ ]]; then
      # Text files by definition end with a newline!
      yaml2json < $config; echo
    else
      jq -c . $config
    fi
  done
}

merge () {
  jq -c 'reduce (., inputs) as $config ({}; . * $config)'
}

# Merge default and user configuration.
scanner | configurables | merge
