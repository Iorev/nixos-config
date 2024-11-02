{ config, pkgs, inputs, ... }:

{ 
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lorev";
  home.homeDirectory = "/home/lorev";
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  nixpkgs.config.allowUnfree = true;
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    godot_4 # open source game engine
    htop-vim # system monitor with vim keybindings
    zathura # pdf viewer with vim keybindings
    nnn #terminal file manager
    eza #modern replacement for ls
    fzf #cli fuzzy finder
    yq
    zoxide
    texliveFull
    (python312.withPackages (p: [
      p.pyyaml
    ]))
    dropbox
    tlrc
    vlc
    graphicsmagick
    grim
    slurp
    zenity
    wl-clipboard
    blender
    android-tools
    sdkmanager
    unzip
    telegram-desktop
    headsetcontrol
    gh
    libsecret
    nchat
    aseprite
    obsidian
    ripgrep
    blueman
    stremio
    rofi-wayland
    kitty
  ];


  imports = [
    ./nixvim.nix
  ];

  gtk= {
    enable = false;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      };
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3";
      };
      iconTheme = {
        package = pkgs.gruvbox-dark-gtk;
        name = "GruvboxPlus";
      };
    };

  programs.git = {
    enable = true;
    userName = "Utisse";
    userEmail = "lorenzopasqui@gmail.com";
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
      push = { autoSetupRemote = true;};
    };
  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      function zathura() {
      		nohup zathura "$@" > /dev/null 2>&1 &
		disown
		exit
		}
	eval "$(zoxide init --cmd cd bash)"
    '';
    shellAliases = {
	ls="ls --color=auto";
	ll="ls -la";
	shtdwn="shutdown now";
        ell = "eza -ls --icons";
    	};
      };
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/hypr/hyperland.conf".source = ./config/hypr/hyperland.conf;
    ".config/hypr/start.sh".source = ./config/hypr/start.sh;

    
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lorev/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
