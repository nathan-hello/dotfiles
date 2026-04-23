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

BRIDGE="win-br$SLOT"

if [ "$MODE" == "detach" ]; then
    echo "Disconnecting $IFACE from $BRIDGE..."

    # Move IP back from bridge to the physical interface
    ADDR_INFO=$(ip -4 addr show "$BRIDGE" | grep -oP 'inet \K\S+')
    ip link set "$IFACE" nomaster
    ip addr flush dev "$BRIDGE"

    if [ -n "$ADDR_INFO" ]; then
        ip addr add "$ADDR_INFO" dev "$IFACE"
        echo "Moved $ADDR_INFO back to $IFACE."
    fi

    echo "Done."
elif [ "$MODE" == "attach" ]; then
    echo "Connecting $IFACE to $BRIDGE..."
    # Ensure bridge exists (it should from start.sh)
    if ! ip link show "$BRIDGE" >/dev/null 2>&1; then
        echo "Error: $BRIDGE does not exist. Is the VM running?"
        exit 1
    fi
    
    # Capture existing IP config from the interface before bridging
    ADDR_INFO=$(ip -4 addr show "$IFACE" | grep -oP 'inet \K\S+')

    # Flush IP from the physical interface and add it to the bridge
    ip addr flush dev "$IFACE"
    ip link set "$IFACE" master "$BRIDGE"
    ip link set "$IFACE" up

    if [ -n "$ADDR_INFO" ]; then
        ip addr add "$ADDR_INFO" dev "$BRIDGE"
        echo "Moved $ADDR_INFO from $IFACE to $BRIDGE."
    else
        echo "No IPv4 address found on $IFACE; bridge has no IPv4."
    fi

    echo "Done. VM Slot $SLOT now has access to $IFACE."
else 
    usage
fi
