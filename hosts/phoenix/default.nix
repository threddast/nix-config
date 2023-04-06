# System configuration for my main desktop PC
{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    #inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/egiorgis

    ../common/optional/gamemode.nix
    ../common/optional/bluetooth.nix
    ../common/optional/ckb-next.nix
    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
 #   ../common/optional/quietboot.nix
    ../common/optional/starcitizen-fixes.nix
    ../common/optional/lol-acfix.nix
  ];

  # environment.persistence.enable = true;

  # TODO: theme "greeter" user GTK instead of using egiorgis to login
  services.greetd.settings.default_session.user = "egiorgis";

  networking = {
    hostName = "phoenix";
    useDHCP = true;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ amdvlk ];
      driSupport = true;
      driSupport32Bit = true;
    };
    opentabletdriver.enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [ virt-manager ];

  system.stateVersion = "22.11";
}
