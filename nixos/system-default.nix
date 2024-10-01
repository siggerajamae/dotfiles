{ pkgs, ... }:

{
  # Host name
  networking.hostName = "sigge-laptop-asus";

  # Hardware acceleration 
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "i965"; };

  # State version
  system.stateVersion = "24.05";
}
