{ pkgs, ... }:


{
  environment.systemPackages = with pkgs; [
  xclip
  vscode.fhs
  (writeShellScriptBin "nvim" ''
    nvim -u /etc/nixos/dirty/nvim/init.lua $@
  '')
];
  environment.variables = {
    EDITOR = "nvim";
  };
}

