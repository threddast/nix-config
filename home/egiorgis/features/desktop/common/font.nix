{ pkgs, ... }: {
  fontProfiles = {
    enable = true;
    monospace = {
      family = "Iosevka Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; };
    };
    regular = {
      family = "Iosevka Aile";
      package = pkgs.iosevka-bin.override { variant = "aile"; };
    };
  };
}
