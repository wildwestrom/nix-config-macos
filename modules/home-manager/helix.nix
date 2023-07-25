{
  inputs,
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [
      python3Packages.python-lsp-server
      alejandra
    ];
  };

  programs = {
    helix = {
      enable = true;
      settings = {
        theme = "kanagawa";
        editor = {
          line-number = "relative";
          auto-format = true;
          true-color = true;
          color-modes = true;
          lsp.display-messages = true;
          auto-pairs = {
            "(" = ")";
            "{" = "}";
            "[" = "]";
            "\"" = "\"";
            "'" = "'";
            "<" = ">";
            "`" = "`";
          };
        };
      };
      languages = {
        language = [
          {
            name = "rust";
            indent = {
              tab-width = 2;
              unit = "\t";
            };
            config = {
              cachePriming = {enable = false;};
              diagnostics = {
                experimental = {
                  enable = true;
                };
              };
            };
            language-server = {
              command = "rust-analyzer";
              rust-analyzer = {
                config = {
                  check = {
                    command = "clippy";
                  };
                };
              };
            };
            debugger = {
              # command = "${inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.debugserver}/bin/debugserver";
              # name = "debugserver";
              command = "${pkgs.lldb}/bin/lldb-vscode";
              name = "lldb-vscode";
              port-arg = "--port {}";
              transport = "tcp";
              templates = [
                {
                  name = "binary";
                  request = "launch";
                  completion = [
                    {
                      completion = "filename";
                      name = "binary";
                    }
                  ];
                  args = {
                    program = "{0}";
                    runInTerminal = true;
                  };
                }
              ];
            };
          }
          {
            name = "nix";
            file-types = ["nix"];
            roots = ["flake.lock"];
            indent = {
              tab-width = 2;
              unit = "\t";
            };
            formatter = {
              command = "${pkgs.alejandra}/bin/alejandra";
              args = ["-"];
            };
            language-server = {
              command = "${pkgs.nil}/bin/nil";
            };
          }
          {
            name = "python";
            formatter = {
              command = "${pkgs.python311Packages.black.out}/bin/black";
              args = ["--quiet" "-"];
            };
          }
        ];
      };
    };
  };
}
