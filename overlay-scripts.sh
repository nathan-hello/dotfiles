#!/bin/sh

scripts=$(
        file /usr/local/bin/* |
        grep -i 'shell' |
        cut -d: -f1
)

printf '%s\n' "$scripts" |
while IFS= read -r f; do
        mkdir -p -- "./scripts$(dirname -- "$f")" &&
        cp -- "$f" "./scripts$f"
done
