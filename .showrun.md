remove dbus notifications
rm /usr/bin/dbus-launch
rm /usr/bin/dbus-daemon

fonts
mv all .otf files in /usr/share/fonts/OTF
fc-cache -v
fc-list | grep <font>
vim ~/.config/fontconfig/fonts.conf
```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match target="pattern">
    <test name="family">
      <string>monospace</string>
    </test>
    <edit name="family" mode="prepend">
      <string>GeistMono Nerd Font Mono</string>
    </edit>
  </match>
</fontconfig>
```

terminal
install zsh with package manager
install oh-my-zsh with curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mv .zshrc ~/.zshrc

audio
xbps-install alsa-utils
use aplay -l to determine output device in .asoundrc, edit accordingly

mv .asoundrc ~/.asoundrc
vim /etc/modules-load.d/snd-aloop.conf
```
snd-aloop
```
echo "ao=alsa" >> ~/.config/mpv/mpv.conf


grub
sudo os-prober
vim /etc/default/grub
```
GRUB_DISABLE_OS_PROBER=false
```
sudo update-grub
