# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ...}:

{
  imports =
    [ 
        ./user-configuration.nix
        ./hardware-configuration.nix

        ./modules/fonts.nix
        ./modules/gaming.nix
        ./modules/editors.nix
        ./modules/desktop.nix
        ./modules/terminal.nix
        ./modules/development.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ebno"; 
  time.timeZone = "America/New_York";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };


 nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vim 
    btop
    wget
    dconf # gtk
    pavucontrol
  ];
  

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  
  fileSystems."/mnt/toby" = {
    device = "192.168.1.6:/mnt/movies";
    fsType = "nfs";
  };

  services.printing.enable = false;
  services.openssh.enable = true;
  networking.firewall = {
  	enable = true;
	allowedTCPPorts = [22];
	allowedUDPPorts = [ ];
  };


  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
   
  system.stateVersion = "24.05"; # Do not change, ever. https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .

}

