{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    feh
    xclip
    dmenu
    flameshot

    (dwm.overrideAttrs (oldAttrs: rec {
		configFile = pkgs.writeText "config.h" (builtins.readFile /etc/nixos/dirty/dwm/config.h);
                patches = [];
		
		postPatch = ''
		        cp ${configFile} config.h;''; 
    }))

    (pkgs.dwmblocks.overrideAttrs (oldAttrs: rec {
      customBlocksDef = pkgs.writeText "blocks.def.h" (builtins.readFile /etc/nixos/dirty/dwm/dwmblocks/blocks.def.h);

      postPatch = ''
        cp ${customBlocksDef} blocks.def.h;
      '';
    }))
];
  services.xserver = {
	enable = true;
	xkb.layout = "us";
	displayManager = { lightdm.enable = true; };
	windowManager= {
		dwm = {
			enable = true;
			package = pkgs.dwm;
		};
  	};

  };

  services.libinput.mouse = {
      accelProfile = "flat";
      accelSpeed = "0.0";
  };

  environment.etc."X11/xinit/xinitrc".text = ''
    feh --bg-scale /etc/nixos/dirty/wallpaper/black.jpg
    dwmblocks &
    exec dwm
  '';
}
