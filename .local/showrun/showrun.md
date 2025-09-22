## fonts

> https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/GeistMono/README.md

mv all .otf files in /usr/share/fonts/OTF
fc-cache -v
fc-list | grep <font>

## terminal

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
```

## grub
sudo os-prober
vim /etc/default/grub
```
GRUB_DISABLE_OS_PROBER=false
```
sudo update-grub



## audio

### alsa
xbps-install alsa-utils
use aplay -l to determine output device in .asoundrc, edit accordingly

mv .asoundrc ~/.asoundrc
vim /etc/modules-load.d/snd-aloop.conf
```
snd-aloop
```
echo "ao=alsa" >> ~/.config/mpv/mpv.conf


## pipewire
follow guide here: https://docs.voidlinux.org/config/media/pipewire.html

$XDG_RUNTIME_DIR is set up inside of .xinitrc
- this env var is necessary for pipewire 
- if you use elogind, remove the XDG_RUNTIME_DIR stuff from .xinitrc
