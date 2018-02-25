# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # --- Additional hardware configuration ---
  
  # Hardware settings.
  hardware = {
    opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
    cpu.intel.updateMicrocode = true;
  };

  # Set /home at external volume/partition.
  fileSystems."/home" = {
    device = "/dev/disk/by-label/home";
    fsType = "ext4";
  };

  # Enable periodic SSD TRIM in background.
  services.fstrim.enable = true;
  
  # -----------------------------------------

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
  };

  # Select internationalisation properties.
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Kiev";

  # Allow non-free packages.
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Essential software.
    git
    htop
    binutils
    viber
    keepass
    firefox
    nix-repl
    mkpasswd
    tdesktop
    skypeforlinux
    libreoffice-fresh
    vlc
    qbittorrent
    zip unzip
    file dos2unix
    spotify

    # Gnome shell related stuff.
    chrome-gnome-shell
    gnome3.gnome-tweak-tool
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.no-title-bar
  ];

  # Packages configurations.
  nixpkgs.config.firefox.enableGnomeExtensions = true;
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    keepass = pkgs.keepass.override {
        plugins = with pkgs; [
           keepass-keepassrpc
        ];
    };
  };

  # Extra fonts added to the system.
  fonts.fonts = with pkgs; [
    emojione
    google-fonts
    anonymousPro
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;

  # List services that you want to enable:

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable X11 server.
  services.xserver.enable = true;

  # Enable the Gnome Shell Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  
  # Exclude garbage packages.
  environment.gnome3.excludePackages = [
      pkgs.gnome3.accerciser
      pkgs.gnome3.gnome-packagekit
      pkgs.gnome3.gnome-software
  ];
  
  # Enable useful services.
  services.gnome3 = {
    # Gnome keyring for applications that require it, such as Skype.
    gnome-keyring.enable = true;
    # Needed for gnome-terminal.
    gnome-terminal-server.enable = true;
    # For extensions.gnome.org to install extensions from browser.
    chrome-gnome-shell.enable = true;
  };

  # Define a user account.
  users.extraUsers.dev = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    # To generate hashed password install mkpasswd package and run mkpasswd -m sha-512.
    hashedPassword = "";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
  system.autoUpgrade.enable = true;
}
