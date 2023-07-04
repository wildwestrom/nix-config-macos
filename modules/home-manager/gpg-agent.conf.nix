{pkgs}: ''
  # TTL
  default-cache-ttl 60
  max-cache-ttl 120

  # SSH
  enable-ssh-support

  # Pinentry config
  allow-emacs-pinentry
  allow-loopback-pinentry
  pinentry-program ${pkgs.pinentry_mac}/bin/pinentry
''
