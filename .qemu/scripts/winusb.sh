#!/usr/bin/env bash
set -eu

QMP_PORT=4444

usage() {
    echo "Usage: sudo winusb {attach|detach} <vendor:product>" >&2
    exit 1
}

[[ $# -ge 2 ]] || usage

ACTION=$1
ID=$2
VENDOR=${ID%%:*}
PRODUCT=${ID##*:}

qmp_cmd() {
    {
        sleep 0.1
        printf '%s\n' '{ "execute": "qmp_capabilities" }'
        sleep 0.1
        printf '%s\n' "$1"
        sleep 0.1
    } | nc -q 1 localhost "$QMP_PORT"
}

case "$ACTION" in
    attach)
        for d in /sys/bus/usb/devices/*; do
            [[ -f "$d/idVendor" && -f "$d/idProduct" ]] || continue

            if [[ $(<"$d/idVendor") == "$VENDOR" &&
                  $(<"$d/idProduct") == "$PRODUCT" ]]; then
                echo "Unbinding host driver from $d..."
                [[ -e "$d/driver/unbind" ]] &&
                    printf '%s' "${d##*/}" >"$d/driver/unbind" 2>/dev/null ||
                    true
            fi
        done

        echo "Attaching $ID to VM..."
        VEN_DEC=$((16#$VENDOR))
        PROD_DEC=$((16#$PRODUCT))

        CMD="{ \"execute\": \"device_add\", \"arguments\": { \"driver\": \"usb-host\", \"vendorid\": $VEN_DEC, \"productid\": $PROD_DEC, \"id\": \"usb-$VENDOR-$PRODUCT\", \"bus\": \"xhci.0\" } }"
        qmp_cmd "$CMD"
        ;;
    detach)
        echo "Detaching usb-$VENDOR-$PRODUCT..."
        CMD="{ \"execute\": \"device_del\", \"arguments\": { \"id\": \"usb-$VENDOR-$PRODUCT\" } }"
        qmp_cmd "$CMD"
        ;;
    *)
        usage
        ;;
esac
