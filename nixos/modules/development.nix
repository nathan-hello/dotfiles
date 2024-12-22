{ pkgs, ... }:


{
  programs.nix-ld.enable = true; # https://nixos.wiki/wiki/DotNET

  environment.systemPackages = with pkgs; [
  vscode.fhs

  (writeShellScriptBin "dev" ''
    export DOTNET_ROOT=${pkgs.dotnetCorePackages.sdk_8_0}/bin
    export PATH=$DOTNET_ROOT:$PATH

    nix-shell -p \
	cargo \
	cmake \
	gcc \
	git \
	go \
	neovim \
	nodejs \
	python3 \
	rustc \
	unzip \
	zig \
        bun \
        csharp-ls \
        dotnetCorePackages.sdk_8_0 \
        dotnetCorePackages.sdk_9_0 \
        omnisharp-roslyn \
        libcap \
    --command "cd ~/dev && zsh"
  '')
];


}
