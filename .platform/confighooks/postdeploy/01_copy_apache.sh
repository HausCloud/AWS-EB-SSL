#!/bin/bash

set -euo pipefail

PREVIOUS_CONFIG_PATH="$HOME/httpd.conf"
CONFIG_PATH="/etc/httpd/conf/httpd.conf"

# Overwrite default configuration

if [ -f "$PREVIOUS_CONFIG_PATH" ] && [ -f "$CONFIG_PATH" ]; then
    cat "$PREVIOUS_CONFIG_PATH" > "$CONFIG_PATH"
fi

service httpd reload
