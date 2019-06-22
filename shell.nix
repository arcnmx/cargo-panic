{
  pkgs ? import <nixpkgs> {
    overlays = [ (import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz)) ];
  }
, rustChannel ? pkgs.lib.findFirst (v: v != "") "stable" [(builtins.getEnv "RUST_CHANNEL")]
}: with pkgs; let
  channel = latest.rustChannels.${rustChannel};
  cargo-panic = import ./default.nix { inherit pkgs; };
in let
  shell = mkShell {
    buildInputs = [ channel.rust jq bash coreutils cargo-panic ];
    passthru.ci = { cmd ? "", backtrace ? builtins.getEnv "RUST_BACKTRACE" }: shell.overrideAttrs (old: {
      shellHook = "cd example";
    } // cargo-panic.example-test.env { inherit cmd backtrace; });
  };
in shell
