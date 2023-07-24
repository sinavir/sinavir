#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

usage="$(basename "$0") [-h] [--dryrun] NODE HOST [-- NIXOS_ANYWHERE_EXTRA_ARGS]
Deploy a brand new nixos system using colmena and nixos anywhere

where:
    -h        Show this help text
    --dryrun  Print the nixos-anywhere invocation

Exemple:
    ./colmena-anywhere.sh node root@example.com"

extra_args=""

while [[ $# -gt 0 ]]; do
  case "$1" in
  --help)
    echo "$usage"
    exit 0
    ;;

  --dry-run)
    dry_run=y
    ;;

  --)
    shift
    extra_args="$*"
    ;;

  *)
    if [[ -z ${node-} ]]; then
      node="$1"
    elif [[ -z ${host-} ]]; then
      host="$1"
    else
      echo "Wrong arguments. Help:"
      echo "$usage"
      exit 1
    fi
    ;;
  esac
  shift
done

if [[ -z ${host-} ]]; then
      echo "Wrong arguments. Help:"
  echo "$usage"
  exit 1
fi

# Get info about the derivation containing the 'nixos-anywhere' invocation
script_infos=$(colmena eval -E "args: import ./colmena-anywhere.nix (args // { node=\"$node\"; host=\"$host\"; extraArgs=\"$extra_args\"; })")

# realise derivation (because colmena eval only eval stuff)
echo "$script_infos" | jq -r ".drvPath" | xargs nix-store -r

# Run !
command=$(echo "$script_infos" | jq -r ".runPath")

if [ "$dry_run" = "y" ]; then
  cat "$command"
else
  $command
fi
