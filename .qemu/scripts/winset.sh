#!/bin/bash

set -euo pipefail

BR1="win-br1"
BR2="win-br2"
TAP1="win-tap1"
TAP2="win-tap2"

USER="nate"
DISK_PATH="/dev/zvol/zroot/qemu/windows"

chown "$USER" "$DISK_PATH"

# We create tap interfaces so QEMU can grab them directly without the helper
setup_bridge() {
    local br=$1
    local tap=$2
    if ! ip link show "$br" >/dev/null 2>&1; then
        echo "Creating bridge $br..."
        ip link add name "$br" type bridge
        ip link set "$br" up
        # Create persistent tap
        ip tuntap add dev "$tap" mode tap
        ip link set "$tap" master "$br"
        ip link set "$tap" up
    fi
}

setup_bridge "$BR1" "$TAP1"
setup_bridge "$BR2" "$TAP2"

