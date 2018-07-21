# stack2nix-with-ghcid

At first, i generated the following workflow with `cabal2nix`, which works.

```bash
$ cabal2nix --shell --no-haddock --no-check --compiler ghc-8.4 . > default.nix
$ nix-build
```

In order to have `ghcid` available when entering `nix-shell`, i added something like

```
  compiler = if pkgs.lib.inNixShell
        then ghc.ghcWithPackages (p: [ p.ghcid ])
        else ghc;
  drv = compiler.callPackage f {};
```

This generally works.

Now, i generated a stackage package list using

```bash
$ stack2nix . > stack_lts_12_1.nix
```

...and adapted the `default.nix` file to use this package list.
`nix-build` and `nix-shell` work on it, but this does not contain the `ghcid` changes.

I made the files `default1.nix` and `default2.nix` hoping that one of both changes would give me a `nix-shell` with `ghcid`, but both have their problems:

Running `nix-shell` on `default1.nix` leads to:

```bash
$ nix-shell
error: anonymous function at /nix/store/6lvgxz247454pgr7ngd0986961jsqsfj-nixpkgs/nixpkgs/pkgs/development/haskell-modules/with-packages-wrapper.nix:1:1 called with unexpected argument 'initialPackages', at /nix/store/6lvgxz247454pgr7ngd0986961jsqsfj-nixpkgs/nixpkgs/lib/customisation.nix:74:12
```

Running `nix-shell` on `default2.nix` leads to:

```bash
$ nix-shell default2.nix
error: anonymous function at /Users/tfc/src/stack2nix-with-ghcid/stack_lts_12_1.nix:16360:10 called without required argument 'CoreServices', at /nix/store/6lvgxz247454pgr7ngd0986961jsqsfj-nixpkgs/nixpkgs/pkgs/development/haskell-modules/make-package-set.nix:88:27
(use '--show-trace' to show detailed location information)
```

`nix-build` still works fine on all these nix files.
