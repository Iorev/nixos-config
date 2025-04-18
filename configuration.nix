{
  config,
  system,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./distributed-builds.nix
    #inputs.sops-nix.nixosModules.sops
  ];

  # TODO: Secret manager
  #SOPS
  #sops = {
  #  defaultSopsFile = ./secrets/secrets.yaml;
  #  defaultSopsFormat = "yaml";
  #  age.keyFile = "/home/lorev/.config/sops/age/keys.txt";
  #  secrets = {
  #    factorio_token = {
  #      owner = "lorev.name";
  #      group = "lorev.group";
  #    };
  #  };
  #};

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "XPSnixos"; # Define your hostname.

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Enable networking
  networking.networkmanager.enable = true;
  # Enable network manager applet
  programs.nm-applet.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    icu
  ];

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable the X11 windowing system.
  services = {
    fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };
    # Enable the GNOME desktop environment
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        banner = ''Bentornato Lorenzo! '';
      };
      desktopManager.gnome.enable = true;
      xkb = {
        layout = "it";
        variant = "";
      };
    };
    envfs.enable = true;

    # Disable CUPS to never print documents.
    printing.enable = false;
    flatpak.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
  };

  # Configure console keymap
  console.keyMap = "it2";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.lorev = {
    isNormalUser = true;
    description = "Lorenzo Pasqui";
    hashedPassword = "$y$j9T$/Zd2ewjXuVjuKz3YzWA3L/$iUOruuv0a6FT1QjzY1ZhTI5OkBxX88ZHXdpAJ6.tBk4";
    extraGroups = [ "dialout" "libvirtd" "networkmanager" "wheel" ];
  };

  programs.adb.enable = true;

  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = ["lorev"];
  };

  # Install Hyperland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };
  environment.sessionVariables = {
    # Wayland stuff
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    #my sessionVariables
    EDITOR = "nvim";
    FLAKE = "/home/lorev/nixos-config";
  };
  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.packageOverrides = pkgs: {
  #  factorio = pkgs.factorio.override {
  #    username = "Utis";
  # This works but it requires to put in the following line a secrets.
  # Is there a better way??
  #    token = "";
  #  };
  #};
  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.dunst
    pkgs.libnotify
    pkgs.swww
    pkgs.networkmanagerapplet
    pkgs.brightnessctl
    pkgs.pavucontrol
    pkgs.waybar
    pkgs.jdk
    pkgs.zoxide
    pkgs.zathura
    pkgs.htop-vim
    pkgs.jq
    pkgs.openresolv
    pkgs.nh
    pkgs.nixd
    pkgs.qemu
    pkgs.sops
    pkgs.nss
    pkgs.wayland
    pkgs.wayland-protocols
    pkgs.wlroots
    pkgs.libxkbcommon
  ];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
    nerd-fonts.mononoki
  ];
  #Install Steam
  programs.steam.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [8080 8081 5829];
  # networking.firewall.allowedUDPPorts = [ ... ];
  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          "/dev/input/by-path/platform-INT33D5:00-event"
          "/dev/input/by-path/platform-PNP0C14:03-event"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
           caps a s d f j k l ;
          )
          (defvar
           tap-time 50
           hold-time 250
          )
          (defalias
           capsesc (tap-hold $tap-time $hold-time esc lmet)
           a (tap-hold $tap-time $hold-time a lmet)
           s (tap-hold $tap-time $hold-time s lalt)
           d (tap-hold $tap-time $hold-time d lsft)
           f (tap-hold $tap-time $hold-time f lctl)
           j (tap-hold $tap-time $hold-time j rctl)
           k (tap-hold $tap-time $hold-time k rsft)
           l (tap-hold $tap-time $hold-time l ralt)
           ; (tap-hold $tap-time $hold-time ; rmet)
          )

          (deflayer base
           @capsesc @a  @s  @d  @f  @j  @k  @l  @;
          )
        '';
      };
    };
  };
  system.stateVersion = "24.05"; # Do not change this 

}
