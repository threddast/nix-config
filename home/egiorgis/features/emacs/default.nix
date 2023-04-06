{ pkgs, config, inputs, ... }: {
  nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

  home.packages = with pkgs; [
    ## Emacs itself
    binutils # native-comp needs 'as', provided by this
    # 28.2 + native-comp
    ((emacsPackagesFor emacsPgtk).emacsWithPackages (epkgs: [ epkgs.vterm ]))

    # for gtk support
    #gsettings-desktop-schemas
    ## Doom dependencies
    #git
    (ripgrep.override { withPCRE2 = true; })
    gnutls # for TLS connectivity

    ## Optional dependencies
    fd # faster projectile indexing
    imagemagick # for image-dired
    #  (lib.mkIf (config.programs.gnupg.agent.enable)
    #   pinentry_emacs)   # in-emacs gnupg prompts
    zstd # for undo-fu-session/undo-tree compression

    ## Module dependencies
    # :checkers spell
    (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
    # :tools editorconfig
    editorconfig-core-c # per-project style config
    # :tools lookup & :lang org +roam
    #sqlite
    # :lang latex & :lang org (latex previews)
    texlive.combined.scheme-medium
    # :lang beancount
    beancount
    fava
    # font
    iosevka-bin
    emacs-all-the-icons-fonts
  ];

  # env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

  # modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

  home.persist.directories = [ ".config/emacs" ".config/doom" ];

  services.emacs = {
    enable = true;
    client.enable = true;
    socketActivation.enable = true;
  };
}
