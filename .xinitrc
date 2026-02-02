#!/bin/sh

export XDG_RUNTIME_DIR="/tmp/$(id -u)-runtime"
if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 0700 "$XDG_RUNTIME_DIR"
fi

# This starts the bus and immediately exports DBUS_SESSION_BUS_ADDRESS
# to the current shell environment so PipeWire AND dwm can see it.
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --exit-with-session --sh-syntax)
fi

pipewire &
pipewire-pulse &
sstat &
exec dwm
