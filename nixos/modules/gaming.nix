{pkgs, ...}:
{
        programs.steam = {
                enable = true;
        };

  environment.systemPackages = with pkgs; [
    (prismlauncher.override {
      jdks = [
        temurin-bin-21
        temurin-bin-8
        temurin-bin-17
      ];
    })
  ];
}
