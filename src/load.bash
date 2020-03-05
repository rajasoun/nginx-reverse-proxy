#!/usr/bin/env bash

## To get all functions : bash -c "source src/load.bash && declare -F"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=src/lib/docker_wrapper.bash
source "$SCRIPT_DIR/lib/docker_wrapper.bash"
# shellcheck source=src/lib/ssh.bash
source "$SCRIPT_DIR/lib/ssl.bash"