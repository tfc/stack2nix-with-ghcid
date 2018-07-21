{ nixpkgs ? import <nixpkgs> {} }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, lens, stdenv }:
      mkDerivation {
        pname = "stack2nix-with-ghcid";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [ base lens ];
        doHaddock = false;
        doCheck = false;
        homepage = "https://github.com/tfc/stack2nix-with-ghcid#readme";
        license = stdenv.lib.licenses.bsd3;
      };

  ghc = pkgs.haskell.packages.ghc843;
  compiler = if pkgs.lib.inNixShell
        then ghc.ghcWithPackages (p: [ p.ghcid ])
        else ghc;

  haskellPackages = import ./stack_lts_12_1.nix { inherit compiler pkgs; };

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
