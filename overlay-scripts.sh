#!/bin/sh

scripts=$(
        file /usr/local/bin/* |
        grep -i 'shell' |
        cut -d: -f1
)

printf '%s\n' "$scripts" |
while IFS= read -r f; do
        mkdir -p -- "./overlay$(dirname -- "$f")" &&
        cp -- "$f" "./overlay$f"
done
