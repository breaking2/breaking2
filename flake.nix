{
  description = "dashi-server flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        llvm = pkgs.llvmPackages_16;
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            buildInputs = [
              openssl
              pkg-config
              bacon
              llvm.llvm
              llvm.clang
              llvm.libclang
              (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
            ];
            shellHook = ''
              export LLVM_CONFIG_PATH=${llvm.llvm}/bin/llvm-config
              export LIBCLANG_PATH=${llvm.libclang.lib}/lib
              echo "LLVM_CONFIG_PATH=$LLVM_CONFIG_PATH"
              echo "LIBCLANG_PATH=$LIBCLANG_PATH"
            '';
            RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
          };
      }
    );
}