{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  system.persist.directories = [ "/var/lib/bluetooth" ];
}
