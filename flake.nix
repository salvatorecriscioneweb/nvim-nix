{
  description = "Salvatore's NeoVim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
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
              rust-analyzer
              gopls
              biome
              typescript-language-server
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
              lazy-nvim
              # autopairs.lua
              nvim-autopairs
              # Blink.lua
              blink-cmp
              # colorscheme.lua
              lackluster-nvim
              # conform.lua
              vim-sleuth
              conform-nvim
              # dashboard
              dashboard-nvim
              # gitsigns.lua
              gitsigns-nvim
              # init.lua
              project-nvim
              lazygit-nvim
              # leap.lua
              flit-nvim
              leap-nvim
              # lsp.lua
              nvim-lspconfig
              fidget-nvim
              lazydev-nvim
              # mini.lua
              mini-nvim
              # neorg.lua
              neorg
              nvim-treesitter
              nvim-treesitter-textobjects
              # oil.lua
              oil-nvim
              # telescope
              telescope-nvim
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
              nvim-web-devicons
              # todo-comments.lua
              todo-comments-nvim
              # tree.lua
              nvim-tree-lua
              # whichkey.lua
              which-key-nvim
              # nvim-treesitter.withAllGrammars
              (nvim-treesitter.withPlugins (
                plugins: with plugins; [
                  bash
                  c
                  diff
                  html
                  lua
                  luadoc
                  markdown
                  markdown_inline
                  query
                  vim
                  vimdoc
                  elixir
                  heex
                  eex
                  norg
                  nix
                ]
              ))
              # Base
              friendly-snippets
              vim-repeat
              mini-icons
              plenary-nvim
            ];
          };

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

          extraPython3Packages = {
            test = _: [ ];
          };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
            test = [ (_: [ ]) ];
          };
        };

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
              aliases = [
                "nv"
              ];
              # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            categories = {
              general = true;
              gitPlugins = true;
              customPlugins = true;
              test = true;
              # we can pass whatever we want actually.
              have_nerd_font = true;
              lexical_derivation = "${pkgs.lexical}/bin/lexical";
            };
          };
      };
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
