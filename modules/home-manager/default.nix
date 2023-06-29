{ pkgs, config, ... }: {
	home = {
		stateVersion = "23.05";
		packages = with pkgs; [
			sd
			lazygit
			tokei
			rustup
			fd
			neovim
			alejandra
			yt-dlp
			cargo-watch
			cargo-make
			cargo-outdated
			nodejs
			bottom
			wget
			tree-sitter
		];
		sessionPath =
			[ "$HOME/.local/bin" "/usr/local/bin" "/run/current-system/sw/bin" ];
		sessionVariables = {
			CLICOLOR = 1;
			EDITOR = "lvim";
		};
		shellAliases = {
			switch-yubikey = "gpg-connect-agent 'scd serialno' 'learn --force' /bye";
			v = "$EDITOR";
			cp = "cp -riv";
			mv = "mv -iv";
			ln = "ln -iv";
			rm = "rm -riv";
			trash = "trash -v";
			mkdir = "mkdir -pv";
			chmod = "chmod -v";
			chown = "chown -v";
			ls = "exa";
			ll = "ls -la";
			la = "ls -a";
			lt = "ls -a --tree";
			"l." = "ls -d .*";
			df = "df -h";
			fd = "fd --hidden";
			rg = "rg -.";
			ag = "ag -a";
			cat = "bat";
			less = "bat --style=plain --paging=always";
			top = "btm --color=default";
			htop = "btm --color=default";
			grep = "rg";
			cloc = "tokei";
			watch = "watch -c";
			nixconf = "$EDITOR ~/nix-config/flake.nix";
			su = "su -s /bin/fish";
			proc = "ps u | head -n1 && ps aux | rg -v '\\srg\\s-\\.' | rg";
			inx =
				"MOZ_ENABLE_WAYLAND=0 GDK_BACKEND=X11 QT_QPA_PLATFORM=xcb WINIT_UNIX_BACKEND=x11";
			mpa = "mpv --no-video";
			ytdl = "yt-dlp -P ~/Downloads";
			hx = "helix";
			gcd1 = "git clone --depth 1";
		};
		# file.".gnupg/gpg-agent.conf".text = import ./gpg-agent.conf.nix {};
		# file.".gnupg/gpg.conf".text = import ./gpg.conf.nix {};
	};
	programs = {
		gpg = {
			enable = true;
		};
		lazygit = { enable = true; };
		bat = {
			enable = true;
			extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
		};
		fzf = {
			enable = true;
			enableFishIntegration = true;
			changeDirWidgetCommand = "fd --type d";
			defaultCommand = "fd --type f";
			fileWidgetCommand = "fd --type f";
		};
		git = {
			enable = true;
			package = pkgs.gitAndTools.gitFull;
			delta.enable = true;
			extraConfig = {
				user = {
					name = "Christian Westrom";
					email = "c.westrom@westrom.xyz";
					# signingKey = config.gpgKey;
				};
				github = {
					user = "wildwestrom";
				};
				gitlab = {
					user = "wildwestrom";
				};
				commit = {
					gpgSign = true;
				};
			};
		};
		exa = {
			enable = true;
			extraOptions = [ "--grid" "--group-directories-first" ];
		};
		starship = {
			enable = true;
			enableFishIntegration = true;
		};
		fish = {
			enable = true;
			interactiveShellInit = "set fish_greeting # Disable greeting\n";
		};
		zoxide = {
			enable = true;
			enableFishIntegration = true;
		};
		ripgrep.enable = true;
		kitty = {
			enable = true;
			shellIntegration.enableFishIntegration = true;
			font = {
				name = "JetBrainsMono";
				size = 14;
			};
			settings = {
				confirm_os_window_close = 0; # Disable
			};
		};
		zathura.enable = true;
		direnv.enable = true;
	};
	editorconfig = {
		enable = true;
		settings = {
			"*" = {
				end_of_line = "lf";
				charset = "utf-8";
				trim_trailing_whitespace = true;
				insert_final_newline = true;
				indent_style = "tab";
				tab_width = 2;
			};
			"*.{fish,py}" = {
				indent_style = "space";
				indent_size = 4;
			};
			"*.yml" = {
				indent_style = "space";
				indent_size = 2;
			};
			"*.{el,clj,cljs,cljc,lisp,cl,scm,fnl,hy,rkt}" = {
				indent_style = "space";
			};
			"*.md" = { trim_trailing_whitespace = false; };
			"README*.md, *.tex" = { max_line_length = 80; };
		};
	};
}
