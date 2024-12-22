{ pkgs, ... }:

{
	environment.systemPackages = [
		pkgs.zsh
		pkgs.oh-my-zsh
	];

	programs.zsh = {
		enable = true;

		ohMyZsh = {
			enable = true;
			plugins = [ "git" ];
		};

	};

	users.users.nate = {
		shell = pkgs.zsh;	
	};

	users.users.root = {
		shell = pkgs.zsh;
	};

        environment.etc = {
                "per-user/alacritty/alacritty.toml".text = builtins.readFile /etc/nixos/dirty/alacritty/alacritty.toml;
                "per-user/zsh/zshrc".text = builtins.readFile /etc/nixos/dirty/zsh/.zshrc;
        };

        system.userActivationScripts = {
         extraUserActivation = {
             text = ''
              ln -sfn /etc/per-user/alacritty ~/.config/
              ln -sfn /etc/per-user/zsh/zshrc ~/.zshrc
            '';
            deps = [];
          };
        };

        environment.variables = {
                TERM = "alacritty";
        };
}
