{ pkgs, ... }:

let 
  geist-mono = pkgs.stdenv.mkDerivation {
    name = "geist-mono";
    version = "1";
    src = /etc/nixos/dirty/fonts/geist-mono;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype/geist-mono
      cp -r "$src"/*.otf $out/share/fonts/truetype/geist-mono
    '';
  };
  sf-mono = pkgs.stdenv.mkDerivation {
        name = "sf-mono";
        version = "1";
        src = /etc/nixos/dirty/fonts/sf-mono;

        installPhase = ''
          mkdir -p $out/share/fonts/truetype/sf-mono
          cp -r "$src"/*.otf $out/share/fonts/truetype/sf-mono
        '';
};
in {
  environment.systemPackages = [
    geist-mono
    sf-mono
  ];

  fonts = {
    fontDir.enable = true;
    fontconfig = {
        defaultFonts = {
                monospace = ["GeistMono Nerd Font Mono"];
        }; 
    };
    packages = [ 
        geist-mono 
        sf-mono
    ];
  };
}

