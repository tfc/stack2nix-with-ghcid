# stack2nix-with-ghcid

At first, generate the following workflow with `cabal2nix`:

```bash
$ cabal2nix --shell --no-haddock --no-check --compiler ghc-8.4 . > default.nix
$ nix-build
```

In order to have `ghcid` available when entering `nix-shell`, i added something like

```
  if pkgs.lib.inNixShell
    then drv.env.overrideAttrs (oldAttrs: {
      buildInputs = with pkgs.haskellPackages; [ ghcid hlint ] ++ oldAttrs.buildInputs;
    })
    else drv
```

Now, i generated a stackage package list using

```bash
$ stack2nix . > stack_lts_12_1.nix
```

...and adapted the `default.nix` file to use this package list.

Running `nix-build` builds the package, but does not lead to `ghcid` and `hlint` being fetched.
Running `nix-shell` puts those tools into your environment.
