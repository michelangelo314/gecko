#!/usr/bin/env bash

## Gecko is a standardized bash interface for xmr-stak

set -o errexit
set -o pipefail

CONFIG_PATH=/usr/local/etc/xmr-config.txt

_print_usage() {
    echo "Usage: $0 <start|config|help>"
}

_start() {
    echo "Gecko: Starting miner..."
    /usr/local/bin/xmr-stak-cpu "$CONFIG_PATH"
}

_config() {
    echo "Gecko: Opening config"
    sudo "$EDITOR" "$CONFIG_PATH"
}

case "$1" in 
    start)   _start          ;;\
    config)  _config         ;;
    *)       _print_usage    ;;
esac