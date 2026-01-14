#!/bin/bash
# Location: /usr/local/bin/winusb
set -eu

QMP_PORT="4444"

function usage() {
    echo "Usage: sudo winusb {attach|detach} <vendor:product>"
    exit 1
}

if [ $# -lt 2 ]; then
   usage
fi

ACTION="$1"
ID="$2"

qmp_cmd() {
    echo "$1" | nc -N localhost $QMP_PORT >/dev/null
}

if [ "$ACTION" == "attach" ]; then
    # Parse Vendor:Product
    VENDOR="${ID%%:*}"
    PRODUCT="${ID##*:}"
    
    # Unbind from Host (Simple, forceful)
    # Find sysfs path by walking USB devices
    for d in /sys/bus/usb/devices/*; do
        if [ -f "$d/idVendor" ] && [ -f "$d/idProduct" ]; then
            if grep -q "$VENDOR" "$d/idVendor" && grep -q "$PRODUCT" "$d/idProduct"; then
                 echo "Unbinding host driver from $d..."
                 echo -n "$(basename "$d")" > "$d/driver/unbind" 2>/dev/null || true
            fi
        fi
    done

    # Tell QEMU to grab it
    echo "Attaching $ID to VM..."
    # Convert hex (0x1234) to decimal for QEMU arguments if needed, 
    # but QEMU usb-host accepts vendorid/productid in hex with '0x' prefix nicely via command line.
    # via QMP 'device_add', we pass decimal.
    
    VEN_DEC=$((16#$VENDOR))
    PROD_DEC=$((16#$PRODUCT))
    
    CMD="{ \"execute\": \"device_add\", \"arguments\": { \"driver\": \"usb-host\", \"vendorid\": $VEN_DEC, \"productid\": $PROD_DEC, \"id\": \"usb-$VENDOR-$PRODUCT\" } }"
    qmp_cmd "$CMD"
    
elif [ "$ACTION" == "detach" ]; then
    VENDOR="${ID%%:*}"
    PRODUCT="${ID##*:}"
    echo "Detaching usb-$VENDOR-$PRODUCT..."
    
    CMD="{ \"execute\": \"device_del\", \"arguments\": { \"id\": \"usb-$VENDOR-$PRODUCT\" } }"
    qmp_cmd "$CMD"
    
    # Note: Rebinding to host usually happens automatically on re-plug, 
    # or you can echo the ID to /sys/bus/usb/drivers_probe
else
  usage  
fi
