include "debug";

def vars:
  def conv:
    .
    | .type = (.value | type)
    | if .type == "null" then
        .conv = ""
      elif .type == "array" then
        .conv = @sh "(\(.value))"
      elif .type == "object" then
        .conv = (
          . as {$key}
          | .value
          | keys
          | map("\($key)_\(. | ascii_upcase)")
          | @sh "(\(.))"
        )
      else
        .conv = @sh "\(.value | @text)"
      end
    | if .type=="array" or .type=="object" then
        .keys = "(\(.value | keys | @sh))"
      elif .type=="number" and (.value | @text | test("[^-0-9]")) then
        .value |= @text
      else
        .
      end
  ;
  def more:
    . as {$key}
    | .value
    | select(iterables)
    | to_entries[]
    | .key |= "\($key)_\(. | @text | ascii_upcase | gsub("[^A-Z0-9_]"; "_"))"
  ;
  def loop:
    conv, (more | loop)
  ;
  loop
;

def declare($flags; $meta):
  .
  | if .conv then . else .conv = (.value | @text | @sh) end
  | (if .type=="number" and (.value|type)=="number" then
      "i"
    elif .keys then
      "a"
    else
      null
    end) as $_flags
  | (if $flags then
      "declare -\($flags + $_flags)"
    elif $_flags then
      "declare -\($_flags)"
    else
      "declare"
    end) as $declare1
  | (if $flags then
      "declare -\($flags)"
    else
      "declare"
    end) as $declare2
  | (
      "\($declare1) \(.key)=\(.conv)",
      if $meta then
        "\($declare2) \(.key)__json=\(.value | @json | @sh)",
        "\($declare2) \(.key)__type=\(.value | type | @sh)",
        (select(.keys) | "\($declare1) \(.key)__keys=\(.keys)")
      else empty end
    )
;

def main($argv):
  . # TODO: Can be nicer in jq 1.6+?
  | ([$argv[]]? // [$argv]) as $argv
  | ($argv[0] // "VAR") as $key
  | ($argv[1] // "rx") as $flags
  | ($argv[2] // false) as $meta
  | to_entries[]
  | .key = "\($key)_\(.key)"
  | vars
  | declare($flags; $meta)
;

def main($key; $flags):
  main([$key, $flags, false])
;

def main($key; $flags; $meta):
  main([$key, $flags, $meta])
;
