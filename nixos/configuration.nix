{ pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix # Generated hardware configuration
    ./system.nix # Additional system specific configuration
    ./rust.nix # Rust configuration
  ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Console keyboard layout
  console.keyMap = "sv-latin1";

  # NetworkManager
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Europe/Stockholm";

  # Pipewire
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true; # Enables support for Bluetooth
    powerOnBoot = true; # Powers up the default Bluetooth controller on boot
    settings = {
      Policy = {
        AutoEnable = "true"; # Automatically enable
      };
    };
  };

  # Touchpad
  services.libinput.enable = true;

  # Users
  users.users.sigge = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # Enable GNOME Keyring
  services.gnome.gnome-keyring.enable = true;

  # No sudo password prompt
  security.sudo.extraRules = [
    {
      users = [ "sigge" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    alacritty
    bemenu
    brightnessctl
    clang
    devenv
    discord
    fd
    firefox
    fzf
    git
    github-cli
    glib
    gnome.adwaita-icon-theme
    gsettings-desktop-schemas
    htop
    inkscape
    libva-utils
    lua-language-server
    neovim
    nixpkgs-fmt
    nnn
    nodejs
    pavucontrol
    python3
    spotify
    sway-contrib.grimshot
    trash-cli
    tree
    nodePackages_latest.typescript-language-server
    nodePackages_latest.svelte-language-server
    unzip
    vlc
    vscode-langservers-extracted
    wget
    wineWowPackages.stagingFull
    wl-clipboard
    xdg-desktop-portal
    xdg-utils
  ];

  # Trusted users
  nix.settings.trusted-users = [ "sigge" ];

  # XDG
  xdg.mime.enable = true;

  # Dynamic libraries for unpackaged programs
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glibc
    libcxx
  ];

  # Enable Polkit
  security.polkit.enable = true;

  # Fonts
  fonts.packages =
    let
      nerdfonts = pkgs.nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
          "CommitMono"
        ];
      };
    in
    with pkgs; [
      nerdfonts
    ];

  # Enable Sway
  programs.sway = {
    enable = true;
    wrapperFeatures.base = true;
    wrapperFeatures.gtk = true;
  };
}
