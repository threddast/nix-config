{ inputs, pkgs, ... }: {
  imports = [
    ./global
    ./features/desktop/hyprland
#    ./features/rgb
    ./features/emacs
    #./features/productivity
    #./features/pass
    ./features/music
  ];

  wallpaper = (import ./wallpapers).aenami-bright-planet;
  colorscheme = inputs.nix-colors.colorschemes.nord;

  monitors = [{
    name = "DP-1";
    width = 5120;
    height = 2160;
    refreshRate = 60;
    x = 0;
    workspace = "1";
  }];
}
