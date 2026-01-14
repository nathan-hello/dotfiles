#!/bin/bash
# Location: /usr/local/bin/wineth
# Usage: sudo wineth <bridge_number> <interface> [detach]

set -eu

function usage() {
    echo "Usage: $(basename "$0") <1|2> <interface> [detach]"
    echo "Example: sudo wineth 1 enp3s0  (Connects enp3s0 to VM Slot 1)"
    exit 1
}

if [ "$#" -lt 2 ]; then
    usage
fi

SLOT="$1"
IFACE="$2"
MODE="${3:-attach}" # Default to attach

BRIDGE="win$SLOT"

if [ "$MODE" == "detach" ]; then
    echo "Disconnecting $IFACE from $BRIDGE..."
    ip link set "$IFACE" nomaster
    echo "Done."
elif [ "$MODE" == "attach" ]; then
    echo "Connecting $IFACE to $BRIDGE..."
    # Ensure bridge exists (it should from start.sh)
    if ! ip link show "$BRIDGE" >/dev/null 2>&1; then
        echo "Error: $BRIDGE does not exist. Is the VM running?"
        exit 1
    fi
    
    ip link set "$IFACE" master "$BRIDGE"
    ip link set "$IFACE" up
    echo "Done. VM Slot $SLOT now has access to $IFACE."
else 
    usage
fi
