{pkgs, ...}: {
  programs.fish.enable = true;
  users.users.main = {
    shell = pkgs.fish;
    description = "Main User";
    home = "/Users/main";
  };
  nix.extraOptions = "	experimental-features = nix-command flakes\n";
  environment = {
    shells = with pkgs; [zsh fish];
    loginShell = pkgs.fish;
    loginShellInit = ''
      export GPG_TTY=$tty
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
    '';
    systemPackages = with pkgs; [coreutils neovim];
    systemPath = ["/opt/homebrew/bin"];
    pathsToLink = ["/Applications"];
  };
  system.keyboard.enableKeyMapping = true;
  fonts.fontDir.enable = true;
  fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})];
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global = {brewfile = true;};
    onActivation = {cleanup = "uninstall";};
    casks = [
      "libreoffice"
      "obs"
      "element"
      "librewolf"
      "mpv"
      "signal"
      "spotify"
      "telegram-desktop"
      "thunderbird"
      "zsa-wally"
      "amethyst"
      "brave-browser"
      "skim"
      "fbreader"
      "anki"
      "vscodium"
      "discord"
      "zoom"
      "gimp"
      "inkscape"
      "pdfsam-basic"
    ];
  };
  system.defaults = {
    dock = {
      autohide = true;
      minimize-to-application = true;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    loginwindow = {GuestEnabled = true;};
    menuExtraClock = {
      Show24Hour = true;
      ShowSeconds = true;
    };
    screencapture = {
      disable-shadow = true;
      location = "/Users/main/Pictures/screenshots/";
      type = "png";
    };
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleShowAllFiles = true;
      AppleTemperatureUnit = "Celsius";
      InitialKeyRepeat = 18;
      KeyRepeat = 2;
      NSDocumentSaveNewDocumentsToCloud = false;
      "com.apple.swipescrolldirection" = false;
    };
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    alf.stealthenabled = 1;
  };
}
