{ outputs, inputs }: {
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}' or
  flake-inputs = final: _: {
    inputs = builtins.mapAttrs
      (_: flake: (flake.packages or flake.legacyPackages or { }).${final.system} or { })
      inputs;
  };

  # Adds my custom packages
  additions = final: prev: import ../pkgs { pkgs = final; } // {
    formats = prev.formats // import ../pkgs/formats { pkgs = final; };
    vimPlugins = prev.vimPlugins // final.callPackage ../pkgs/vim-plugins { };
  };

  # Modifies existing packages
  modifications = final: prev: {
    vimPlugins = prev.vimPlugins // {
      vim-numbertoggle = prev.vimPlugins.vim-numbertoggle.overrideAttrs (oa: {
        patches = (oa.patches or [ ]) ++ [ ./vim-numbertoggle-command-mode.patch ];
      });
    };

    xdg-utils-spawn-terminal = prev.xdg-utils.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [ ./xdg-open-spawn-terminal.diff ];
    });

    pfetch = prev.pfetch.overrideAttrs (oldAttrs: {
      version = "unstable-2021-12-10";
      src = final.fetchFromGitHub {
        owner = "dylanaraps";
        repo = "pfetch";
        rev = "a906ff89680c78cec9785f3ff49ca8b272a0f96b";
        sha256 = "sha256-9n5w93PnSxF53V12iRqLyj0hCrJ3jRibkw8VK3tFDvo=";
      };
      # Add term option, rename de to desktop, add scheme option
      patches = (oldAttrs.patches or [ ]) ++ [ ./pfetch.patch ];
    });

    # Sane default values and crash avoidance (https://github.com/k-vernooy/trekscii/pull/1)
    trekscii = prev.trekscii.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [ ./trekscii.patch ];
    });

    scgit = prev.cgit-pink.overrideAttrs (_: {
      pname = "scgit";
      version = "0.1";
      src = final.fetchFromSourcehut {
        owner = "~egiorgis";
        repo = "scgit";
        rev = "2cd05c95827fb94740e876733dc6f7fe88340de2";
        sha256 = "sha256-95mRJ3ZCSkLHqehFQdwM2BY0h+YDhohwpnRiF6/lZtA=";
      };
    });

    prismlauncher = prev.prismlauncher.overrideAttrs (oa: {
      patches = (oa.patches or [ ]) ++ [ ./offline-mode-prism-launcher.diff ];
    });

    # TODO https://github.com/NixOS/nixpkgs/issues/205014
    khal = prev.khal.overrideAttrs (oa: {
      disabledTests = oa.disabledTests ++ [
        "event_test"
        "vtimezone_test"
        "test_split_ics"
        "test_get"
        "test_construct_event_format_de"
        "test__construct_event_format_us"
        "test__construct_event_format_de_complexer"
        "test_leap_year"
        "test_description"
        "test_repeat_floating"
        "test_repeat_localized"
        "test_alarm"
        "test_description_and_location_and_categories"
      ];
    });
    todoman = prev.todoman.overrideAttrs (oa: {
      disabledTests = oa.disabledTests ++ [
        "test_datetime_serialization"
      ];
    });
  };
}
