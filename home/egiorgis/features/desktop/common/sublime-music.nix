{ pkgs, lib, ... }: {
  home.packages = [ pkgs.sublime-music ];
  home.persist.directories = [ ".config/sublime-music" ];
}
