{ pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix # Generated hardware configuration
    ./system.nix # Additional system specific configuration
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
    cargo
    clang
    discord
    fd
    firefox
    fzf
    git
    github-cli
    grim
    htop
    libva-utils
    neovim
    nixpkgs-fmt
    nnn
    pavucontrol
    spotify
    sway
    trash-cli
    tree
    unzip
    vlc
    wget
    wl-clipboard
  ];

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
    wrapperFeatures.gtk = true;
  };
}
