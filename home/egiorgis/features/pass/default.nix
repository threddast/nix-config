{ pkgs, lib, ... }:
let
  pass-otp = pkgs.passExtensions.pass-otp.overrideAttrs (oa: {
    # https://github.com/tadfisher/pass-otp/pull/173
    patches = (oa.patches or [ ]) ++ [ ./pass-otp-fix-completion.patch ];
  });
in
{

  programs.password-store = {
    enable = false;
    settings = { PASSWORD_STORE_DIR = "$HOME/.password-store"; };
    package = pkgs.pass.withExtensions (_: [ pass-otp ]);
  };

  home.persist.directories = [ ".password-store" ];
}
