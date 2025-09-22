# Initial Setup

## Download ISOs

> Windows 11 ISO: https://www.microsoft.com/en-us/software-download/windows11
to `~/.qemu/iso/win11.iso`.

>VirtIO ISO: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/
inside `latest-virtio/virtio-win.iso` to `~/.qemu/iso/virtio-win.iso`.

Allow QEMU to allow the bridges by copying the configuration file:

```bash 
sudo cp etc-qemu-bridge.conf /etc/qemu/bridge.conf 
```

## Start the VM

Start the VM by running the `windows` command. Run this in a terminal to view
error messages.

You may encounter errors related to OVMF. These can be resolved by locating the
`OVMF_VARS.fd` and `OVMF_CODE.fs` files. Use `xbps-query -f edk2-ovmf` to help
locate them if needed. Assign the path to `OVMF_VARS.fd` to `OVMF_VARS` and
`OVMF_CODE.fs` to `OVMF_CODE`.

## Windows Installer

### Disable TPM

During the Windows installation, press `Shift+F10` to open the command prompt,
then type `regedit` and press Enter.

Navigate to `HKEY_LOCAL_MACHINE\SYSTEM\Setup`.

1.  Right-click on the `Setup` folder.
2.  Select `New` > `Key`, and name it "LabConfig".
3.  Right-click on the `LabConfig` folder.
4.  Select `New` > `DWORD (32-bit) Value`, and name it "BypassSecureBootCheck".
Set its value to `1`.
5.  Repeat step 4, naming the new DWORD "BypassRAMCheck" and setting its value
to `1`.

### Install VirtIO Drivers

When you reach the partition selection screen, no partitions will be shown.

1.  Click "Load driver".
2.  Browse to the VirtIO CD drive.
3.  Navigate to the `/viostor/w11/amd64` folder.
4.  Select the "Red Hat VirtIO SCSI controller" driver. If two identical
drivers are displayed, select the first one.

After the driver is installed, select a partition and proceed with the
installation.

After the initial reboot, continue through the setup menus until you reach the
"add a second keyboard layout" screen. Press `Shift+F10` and run `start
ms-cxh:localonly`.

### Enable Networking

1.  Open Device Manager.
2.  Under "Other devices," locate the "Ethernet Controller" with a yellow
exclamation mark.
3.  Right-click on the "Ethernet Controller" and select "Update driver".
4.  Choose "Browse my computer for drivers".
5.  Click the "Browse..." button and select the CD-ROM drive containing your
`virtio-win.iso`.
6.  Check "Include subfolders".
7.  Click "Next".

## USB Devices

To attach a USB device, first identify its Bus and Device numbers using
`lsusb`. For example, `001:007`.

```bash
winusb attach 001:007 
```

To detach the USB device:

```bash
winusb detach 001:007 
```

## Ethernet

Attach an Ethernet interface to a bridge using the `wineth attach` command:

```bash
wineth attach <local_interface> <bridge_interface> 
```

For example:

```bash
wineth attach eth0 br0 
```

You can then change the IP address within Windows, and it will function as
expected.
