# Create snapshot

current_date = $(date +%Y-%m-%d)
zfs snapshot -r "zroot@$current_date"

## Full wipe and load
sudo zfs send -Rwv "zroot@$current_date" | ssh toby "doas zfs recv -Fu -v nfs/ebno"

## Incremental

sudo zfs send -Rwi zroot@2026-01-26 "zroot@$current_date" | ssh toby "doas zfs recv -u -v nfs/ebno"
                                                                                ^ use -Fu if the snapshot on local is different than snapshot
                                                                                on remote and they are named the same
  - -i will account for the snapshots in between 2026-01-26 and $current_date automatically



The snapshots/pools on the server have canmount=off
and no mountpoint because the server should not be
mounting these pools. When importing from the server
(however it is you will do that), after you have them
you must run the following commands to get them to mount

zfs list -r -o name,canmount,mountpoint nfs/ebno

doas zfs set canmount=on <pool>
doas zfs set mountpoint=<where-you-want-it> <pool>

NAME                CANMOUNT  MOUNTPOINT
zroot               on        none
zroot/ROOT          on        none
zroot/ROOT/void     noauto    /
zroot/home          on        /home
zroot/qemu          on        none
zroot/qemu/windows  -         -

so, run:
```sh
sudo zfs set canmount=on     zroot              
sudo zfs set canmount=on     zroot/ROOT         
sudo zfs set canmount=noauto zroot/ROOT/void    
sudo zfs set canmount=on     zroot/home         
sudo zfs set canmount=on     zroot/qemu         
sudo zfs set canmount=on     zroot/qemu/windows 

sudo zfs set mountpoint=/ zroot/ROOT/void
sudo zfs set mountpoint=/home zroot/home
```
just turn on canmount=on for the rest of them
