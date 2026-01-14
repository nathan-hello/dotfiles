#!/bin/bash
set -euo pipefail

BASE="$HOME/.qemu"
ISO_WIN="$BASE/iso/win11-24H2.iso"
ISO_VIRTIO="$BASE/iso/virtio-win-0.1.240.iso"
DISK_PATH="/dev/zvol/zroot/qemu/windows"

# Secure Boot / TPM
OVMF_CODE="/usr/share/edk2/x64/OVMF_CODE.secure.fd"
OVMF_VARS="$BASE/OVMF_VARS.fd"
TPM_DIR="$BASE/tpm"

# Network Bridges
# Windows will see these as "Ethernet 2" and "Ethernet 3"
TAP1="win-tap1"
TAP2="win-tap2"

MEMORY="32G"
CORES="8"

# 1. Setup TPM
mkdir -p "$TPM_DIR"
swtpm socket --tpm2 --tpmstate dir="$TPM_DIR" \
    --ctrl type=unixio,path="$TPM_DIR/swtpm-sock" &
SWTPM_PID=$!

cleanup() {
    kill $SWTPM_PID 2>/dev/null
    # We leave bridges up to avoid disrupting host network if reused
}
trap cleanup EXIT

args=(
  -name "windows"
  -enable-kvm
  -machine type=q35,smm=on,accel=kvm,usb=on
  -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,hv_frequencies,hv_stimer,hv_synic,hv_reset,hv_vpindex,hv_runtime,host-cache-info=on,l3-cache=on
  -smp "$CORES",sockets=1,dies=1,cores="$CORES",threads=1 
  -m "$MEMORY"
  -qmp tcp:127.0.0.1:4444,server,nowait
  -device usb-tablet
  # -boot menu=on,splash-time=1000

  # Secure Boot
  -global driver=cfi.pflash01,property=secure,value=on
  -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE"
  -drive if=pflash,format=raw,file="$OVMF_VARS"

  # TPM
  -chardev socket,id=chrtpm,path="$TPM_DIR/swtpm-sock"
  -tpmdev emulator,id=tpm0,chardev=chrtpm
  -device tpm-tis,tpmdev=tpm0

  # Storage
  -device virtio-scsi-pci,id=scsi0
  -drive file="$DISK_PATH",format=raw,if=none,id=drive0,cache=none,aio=native,discard=unmap
  -device scsi-hd,drive=drive0,bus=scsi0.0

  # Network 1: User NAT
  -netdev user,id=net0
  -device virtio-net-pci,netdev=net0,mac=52:54:00:00:00:01

  # Network 2: Passthrough 1
  -netdev tap,id=net1,ifname="$TAP1",script=no,downscript=no
  -device virtio-net-pci,netdev=net1,mac=52:54:00:00:00:02

  # Network 3: Passthrough 2
  -netdev tap,id=net2,ifname="$TAP2",script=no,downscript=no
  -device virtio-net-pci,netdev=net2,mac=52:54:00:00:00:03

  # VirtIO Drivers
  -device ide-cd,drive=virtioiso
  -drive file="$ISO_VIRTIO",if=none,id=virtioiso,media=cdrom,readonly=on

  # Disable default legacy graphics card to prevent "Ghost Monitor"
  -vga none 

  # Display - QXL
  # We use QXL because the QXL WDDM driver handles dynamic
  # resolution changes much better than the VirtIO DOD driver.
  -device qxl-vga,ram_size_mb=128,vgamem_mb=64
  -display gtk,gl=off,grab-on-hover=on,zoom-to-fit=off
  -spice port=5900,addr=127.0.0.1,disable-ticketing=on
  -device virtio-serial-pci
  -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0
  -chardev spicevmc,id=spicechannel0,name=vdagent

  # Display - Virtio
  # Unused because when it is used there are no resolution options in Windows. 
  # As in, there is no way to change the resolution manually ever at all.
  # -device virtio-gpu-pci
  # -display gtk,gl=off,grab-on-hover=on
)

qemu-system-x86_64 "${args[@]}"

# args_installer=(
#   -name "Win11-Installer"
#   -enable-kvm
#   -machine type=q35,smm=on,accel=kvm,usb=on
#   -cpu host,topoext,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time
#   -smp cores="$CORES",threads=1,sockets=1
#   -m "$MEMORY"
#   -qmp tcp:127.0.0.1:4444,server,nowait
# 
#   # --- SAFE MODE DISPLAY ---
#   # Standard VGA is the most compatible for boot prompts.
#   -device VGA
#   -display gtk,gl=off
# 
#   # --- INPUT ---
#   # Standard PS/2 Keyboard/Mouse. 
#   # Note: Mouse will feel weird/sticky without usb-tablet. This is expected.
#   # We just need the Keyboard to work for the boot prompt.
#   -device usb-kbd
# 
#   # --- BOOT DELAY ---
#   -boot menu=on,splash-time=1000
# 
#   # --- SECURE BOOT ---
#   -global driver=cfi.pflash01,property=secure,value=on
#   -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE"
#   -drive if=pflash,format=raw,file="$OVMF_VARS"
# 
#   # --- TPM ---
#   -chardev socket,id=chrtpm,path="$TPM_DIR/swtpm-sock"
#   -tpmdev emulator,id=tpm0,chardev=chrtpm
#   -device tpm-tis,tpmdev=tpm0
# 
#   # --- STORAGE (ZFS) ---
#   -device virtio-scsi-pci,id=scsi0
#   -drive file="$DISK_PATH",format=raw,if=none,id=drive0,cache=none,aio=native,discard=unmap
#   -device scsi-hd,drive=drive0,bus=scsi0.0
# 
#   # --- STORAGE (SATA CONTROLLER) ---
#   # Explicitly create an AHCI controller to avoid "bus supports only 1 unit" errors
#   -device ich9-ahci,id=sata0
# 
#   # --- INSTALLER (CD-ROM 1) ---
#   # Bootindex 0 forces this to be the priority
#   -device ide-cd,bus=sata0.0,drive=winiso,bootindex=0
#   -drive file="$ISO_WIN",if=none,id=winiso,media=cdrom,readonly=on
# 
#   # --- VIRTIO DRIVERS (CD-ROM 2) ---
#   -device ide-cd,bus=sata0.1,drive=virtioiso
#   -drive file="$ISO_VIRTIO",if=none,id=virtioiso,media=cdrom,readonly=on
# 
#   # --- NETWORK ---
#   -netdev user,id=net0
#   -device virtio-net-pci,netdev=net0,mac=52:54:00:00:00:01
# )

