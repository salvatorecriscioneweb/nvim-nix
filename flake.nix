{
  description = "Salvatore's NeoVim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
  };

  # see :help nixCats.flake.outputs
  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = {
        # allowUnfree = true;
      };
      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
      ];
      categoryDefinitions =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkNvimPlugin,
          ...
        }@packageDef:
        {
          lspsAndRuntimeDeps = with pkgs; {
            general = [
              tree-sitter
              universal-ctags
              ripgrep
              fd
              stdenv.cc.cc
              nix-doc
              lua-language-server
              nixd
              stylua
              lexical
              biome
            ];
            kickstart-debug = [
              delve
            ];
            kickstart-lint = [
              markdownlint-cli
            ];
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = with pkgs.vimPlugins; {
            general = [
              vim-sleuth
              lazy-nvim
              comment-nvim
              gitsigns-nvim
              which-key-nvim
              telescope-nvim
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
              nvim-web-devicons
              plenary-nvim
              nvim-lspconfig
              lazydev-nvim
              fidget-nvim
              conform-nvim
              nvim-cmp
              luasnip
              cmp_luasnip
              cmp-nvim-lsp
              cmp-path
              todo-comments-nvim
              mini-nvim
              # nvim-treesitter.withAllGrammars
              (nvim-treesitter.withPlugins (
                plugins: with plugins; [
                  nix
                  lua
                  typescript
                  elixir
                  eex
                  heex
                  markdown
                  yaml
                ]
              ))
              # Added
              project-nvim
              nightfox-nvim
              dashboard-nvim
              flit-nvim
              leap-nvim
              vim-repeat
              nvim-tree-lua
              oxocarbon-nvim
            ];
            kickstart-debug = [
              nvim-dap
              nvim-dap-ui
              nvim-dap-go
              nvim-nio
            ];
            kickstart-indent_line = [
              indent-blankline-nvim
            ];
            kickstart-lint = [
              nvim-lint
            ];
            kickstart-autopairs = [
              nvim-autopairs
            ];
            kickstart-neo-tree = [
              neo-tree-nvim
              nui-nvim
              # nixCats will filter out duplicate packages
              # so you can put dependencies with stuff even if they're
              # also somewhere else
              nvim-web-devicons
              plenary-nvim
            ];
          };

          # not loaded automatically at startup.
          # use with packadd and an autocommand in config to achieve lazy loading
          # NOTE: this template is using lazy.nvim so, which list you put them in is irrelevant.
          # startupPlugins or optionalPlugins, it doesnt matter, lazy.nvim does the loading.
          # I just put them all in startupPlugins. I could have put them all in here instead.
          optionalPlugins = { };

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs; [
              # libgit2
            ];
          };

          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            test = {
              CATTESTVAR = "It worked!";
            };
          };

          # If you know what these are, you can provide custom ones by category here.
          # If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            test = [
              ''--set CATTESTVAR2 "It worked again!"''
            ];
          };

          # lists of the functions you would have passed to
          # python.withPackages or lua.withPackages

          # get the path to this python environment
          # in your lua config via
          # vim.g.python3_host_prog
          # or run from nvim terminal via :!<packagename>-python3
          extraPython3Packages = {
            test = _: [ ];
          };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
            test = [ (_: [ ]) ];
          };
        };

      # And then build a package with specific categories from above here:
      # All categories you wish to include must be marked true,
      # but false may be omitted.
      # This entire set is also passed to nixCats for querying within the lua.

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim =
          { pkgs, ... }:
          {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              wrapRc = true;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [
                "nv"
              ];
              neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            categories = {
              general = true;
              gitPlugins = true;
              customPlugins = true;
              test = true;

              kickstart-autopairs = true;
              kickstart-neo-tree = false;
              kickstart-debug = false;
              kickstart-lint = true;
              kickstart-indent_line = false;

              # this kickstart extra didnt require any extra plugins
              # so it doesnt have a category above.
              # but we can still send the info from nix to lua that we want it!
              kickstart-gitsigns = true;

              # we can pass whatever we want actually.
              have_nerd_font = true;
              lexical_derivation = "${pkgs.lexical}/bin/lexical";

              example = {
                youCan = "add more than just booleans";
                toThisSet = [
                  "and the contents of this categories set"
                  "will be accessible to your lua with"
                  "nixCats('path.to.value')"
                  "see :help nixCats"
                  "and type :NixCats to see the categories set in nvim"
                ];
              };
            };
          };
      };
      # In this section, the main thing you will need to do is change the default package name
      # to the name of the packageDefinitions entry you wish to use as the default.
      defaultPackageName = "nvim";
    in
    # see :help nixCats.flake.outputs.exports
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one passed in here.
        packages = utils.mkAllWithDefault defaultPackage;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = '''';
          };
        };
      }
    )
    // (
      let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {
        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
