$ sudo zfs set org.zfsbootmenu:commandline="quiet amdgpu.aspm=0 amdgpu.runpm=0" zroot/ROOT

> amdgpu.aspm=0: Disables Active State Power Management. This is the #1 cause
> of frame buffer update failures on new mobile Ryzen chips because the PCIe
> link transitions to a sleep state faster than the app can push a new frame.

> amdgpu.runpm=0: Disables runtime power management, preventing the GPU from
> entering a "D3" state while X11 is active.


/etc/X11/xorg.conf.d/10-amdgpu.conf

Section "OutputClass"
	Identifier "AMDgpu DRI2"
	MatchDriver "amdgpu"
	Driver "amdgpu"
	Option "HotplugDriver" "amdgpu"
#        Option "DRI" "3"
EndSection

Setting `Option "DRI" "2"` worked to resolve the frame buffer getting jacked up in qemu and qutebrowser
but it meant that I got 5 fps in minecraft. Have not tried DRI 3, though that should be the default. 
