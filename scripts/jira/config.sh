#!/bin/bash -n
#### MUST BE SOURCED.

merge () {
  if $JIRA_OPT_COMPACT; then
    flags=(-c)
  else
    flags=()
  fi
  jq "${flags[@]}" 'reduce (., inputs) as $config ({}; . * $config)'
}

main () {
  # Expand ~ to HOME.
  path=${JIRA_OPT_FILE/#\~\//$HOME\/}

  # Get disk config.
  if [[ -r $path ]]; then
    one=$(yaml2json < $path)
  else
    one='{}'
  fi

  # Get item config.
  if [[ $JIRA_ARG_ITEM__type == object ]]; then
    two=$JIRA_ARG_ITEM__json
  else
    two='{}'
  fi

  # Write to stdout or --file.
  if [[ $JIRA_ARG_ITEM__type == null || $path == \- ]]; then
    printf '%s\n' $one $two | merge
  else
    printf '%s\n' $one $two | merge > $path
  fi
}
