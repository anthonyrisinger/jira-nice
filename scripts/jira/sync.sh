#!/bin/bash -n
#### MUST BE SOURCED.

sync () {
  local doc="$1" out="$1.sync"
  local keys=(id key name desc ac size stories tasks)
  local keysl="[$(IFS=,; echo "${keys[*]/#/.}")]"
  local filter='.issues[] | '$keysl' | map(. | @json) | join("\t")'
  declare "${keys[@]/%/=}"

  info "[$doc] Processing document..."

  mkdir -p $out
  while IFS=$'\t' read -r "${keys[@]}"; do
    debug "       id: $id ${#id}"
    debug "      key: $key"
    debug "     name: $name"
    debug "     desc: $desc"
    debug "       ac: $ac"
    debug "     size: $size"
    debug "  stories: $stories"
    debug "    tasks: $tasks"
  done < <(yaml2json < $doc | jq -rc "$filter")

  info "[$doc] Done."
}

main () {
  info "Processing ${#JIRA_ARG_DOC[@]} document(s)..."

  for doc in "${JIRA_ARG_DOC[@]}"; do
    ! [[ -r "$doc" ]] &&
      error "[$doc] Document does not exist or is unreadable." &&
      continue

      sync $doc
  done

  info "Done."
}
