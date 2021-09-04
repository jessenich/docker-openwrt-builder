#!/bin/bash

SCRIPT_DIR="${1:-"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"}"

/bin/bash "$SCRIPT_DIR/scripts/feeds" update -a
/bin/bash "$SCRIPT_DIR/scripts/feeds" install -a