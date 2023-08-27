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
        theme = "onelight";
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
          soft-wrap = {
            enable = true;
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
          {
            name = "typst";
            file-types = ["typ"];
            scope = "source.typst";
            injection-regex = "^typ(st)?$";
            roots = [];
            comment-token = "//";
            indent = {
              tab-width = 2;
              unit = "\t";
            };
            auto-pairs = {
              "(" = ")";
              "{" = "}";
              "[" = "]";
              "\"" = "\"";
              "`" = "`";
              "$" = "$";
            };
            text-width = 100;
            rulers = [100];
            soft-wrap.wrap-at-text-width = true;
            language-server = {
              command = "${pkgs.typst-lsp}/bin/typst-lsp";
            };
            formatter = {
              command = "${pkgs.typst-fmt}/bin/typst-fmt";
              args = ["--stdio"];
            };
            # # TODO: Fix grammar adding to helix config
            # # https://github.com/nix-community/home-manager/issues/2871            
            #  grammar = {
            #    name = "typst";
            #    source = {
            #      # git = "https://github.com/SeniorMars/tree-sitter-typst";
            #      # rev = "2e66ef4b798a26f0b82144143711f3f7a9e8ea35";
            #      git = "https://github.com/frozolotl/tree-sitter-typst";
            #      rev = "427ccd875e14b592f13c2fac866158afa04034cb";
            #    };
            #  };
          }
        ];
      };
    };
  };
}
