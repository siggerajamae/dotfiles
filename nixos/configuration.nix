{ config, lib, pkgs, ... }:

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
            users = ["sigge"];
            commands = [
                {
                    command = "ALL";
                    options = ["NOPASSWD"];
                }
            ];
        }
    ];

    # System packages
    environment.systemPackages = with pkgs; [
        neovim
        wget
        firefox
        tree
        sway
        wl-clipboard
        grim
        bemenu
        alacritty
        git
        cargo
        clang
        libva-utils
        fzf
        fd
        unzip
        libva-utils
        github-cli
        vlc
        htop
        nnn
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
        in with pkgs; [
            nerdfonts
        ];

    # Enable Sway
    programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
    };
}
