{
  config,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lorev";
  home.homeDirectory = "/home/lorev";

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = ./config/wallpaper/nix-colored.png;
    opacity = {
      applications = 0.1; #This doesn't seem to work
      desktop = 0.75;
      popups = 0.85;
      terminal = 0.75;
    };

    cursor = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors (Gruvbox)";
    };
    fonts = {
      serif = {
        package = pkgs.fira-sans;
        name = "FiraSans";
      };
      sansSerif = {
        package = pkgs.fira-sans;
        name = "FiraSans";
      };
      monospace = {
        package = pkgs.fira-mono;
        name = "Fira Code nerd font mono";
      };
    };
  };
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    inputs.nixvim.packages.${pkgs.system}.default
    pkgs.htop-vim # system monitor with vim keybindings
    pkgs.zathura # pdf viewer with vim keybindings
    pkgs.nnn #terminal file manager
    pkgs.eza #modern replacement for ls
    pkgs.fzf #cli fuzzy finder
    pkgs.yq
    pkgs.zoxide
    pkgs.texliveFull
    (pkgs.python3.withPackages (python-pkgs:
      with python-pkgs; [
        # select Python packages here
        pyyaml
      ]))
    pkgs.dropbox
    pkgs.tlrc
    pkgs.vlc
    pkgs.graphicsmagick
    pkgs.grim
    pkgs.slurp
    pkgs.zenity
    pkgs.wl-clipboard
    pkgs.unzip
    pkgs.telegram-desktop
    pkgs.headsetcontrol
    pkgs.gh
    pkgs.libsecret
    pkgs.nchat
    pkgs.ripgrep
    pkgs.blueman
    pkgs.stremio
    pkgs.kitty
    pkgs.alejandra
    pkgs.base16-schemes
    pkgs.onedrive
    pkgs.viu
    pkgs.vimiv-qt
    pkgs.gammastep
    pkgs.virt-manager
    pkgs.tut
    pkgs.clang
    pkgs.ytfzf
    pkgs.calibre
    pkgs.whatsie
    pkgs.bitwarden
    pkgs.rclone
    pkgs.rclone-browser
    pkgs.chromium
    pkgs.localsend
    pkgs.libreoffice-qt
    pkgs.gimp
    pkgs.hacompanion
  ]; #END OF PACKAGES

  programs.btop.enable = true;
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };
  programs.git = {
    enable = true;
    userName = "Utisse";
    userEmail = "lorenzopasqui@gmail.com";
    extraConfig = {
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
      push = {autoSetupRemote = true;};
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
      #ls = "ls --color=auto";
      #ll = "ls -la";
      shtdwn = "shutdown now";
      ls = "eza";
      ll = "eza -la";
      ett = "eza --tree";
    };
  };
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/waybar/watch_course.sh".text = ''
      #!/bin/bash
      cat /tmp/current_course'';
    ".config/wallpaper/recolor_wallpaper.sh".text = ''
      gm convert -background "#${config.lib.stylix.colors.base00}" -flatten nix-transp.png /home/lorev/nixos-config/config/wallpaper/nix-colored.png
    '';
    ".config/wallpaper/nix-transp.png".source = ./config/wallpaper/nix-transp.png;
    #".config/emacs/init.el".source = ./config/emacs/init.el;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [
    #./programs/nixvim
    ./programs/kitty.nix
    ./programs/hyprland.nix
    ./programs/waybar.nix
    ./programs/zathura.nix
    ./programs/firefox.nix
    ./programs/rofi.nix
    ./programs/thunderbird.nix
    #./programs/emacs.nix
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
