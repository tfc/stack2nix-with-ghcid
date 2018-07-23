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
  haskellPackages = (import ./stack_lts_12_1.nix { inherit compiler pkgs; }).override {
    overrides = self: super: {
      # This override is necessary because of https://github.com/input-output-hk/stack2nix/issues/85
      inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa CoreServices;
    };
  };


  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell
    then drv.env.overrideAttrs (oldAttrs: {
      buildInputs = with pkgs.haskellPackages; [ ghcid hlint ] ++ oldAttrs.buildInputs;
    })
    else drv
