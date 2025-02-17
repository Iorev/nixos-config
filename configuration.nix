# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
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

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    xserver.enable = true;
    fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };
    # Enable the GNOME desktop environment
    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    envfs.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "it";
      variant = "";
    };
    # Disable CUPS to print documents.
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lorev = {
    isNormalUser = true;
    description = "Lorenzo Pasqui";
    hashedPassword = "$y$j9T$/Zd2ewjXuVjuKz3YzWA3L/$iUOruuv0a6FT1QjzY1ZhTI5OkBxX88ZHXdpAJ6.tBk4";
    extraGroups = ["libvirtd" "networkmanager" "wheel"];
    #packages = with pkgs; [
    #  thunderbird
    #];
  };
  # Enable automatic login for the user.
  #services.displayManager.autoLogin= {
  #  enable = true;
  #  user = "lorev";
  #};
  # Install firefox.
  programs.firefox.enable = true;

  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = ["lorev"];
  };

  programs.kdeconnect.enable = true;
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
  # List packages installed in system profile. To search, run:
  # $ nix search wget
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

  virtualisation.libvirtd.enable = true;
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = true;
    };
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [8080 8081];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = false;

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
           tap-time 200
           hold-time 300
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
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  #home-manager.users.lorev = { pkgs, ... }: {

  #	home.packages = with pkgs; [];
  #	home.stateVersion = "24.05";

  ## };
}
