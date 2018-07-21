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

  compiler = pkgs.haskell.packages.ghc843;

  haskellPackages_ = import ./stack_lts_12_1.nix { inherit compiler pkgs; };

  haskellPackages = if pkgs.lib.inNixShell
        then haskellPackages_.ghcWithPackages (p: [ p.ghcid ])
        else haskellPackages_;

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
