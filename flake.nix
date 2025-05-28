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
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            buildInputs = [
              # for GitHub Actions
              llvmPackages_20.libllvm
              llvmPackages_20.clang-unwrapped
              # for NixOS
              openssl
              pkg-config
              bacon
              opencv
              llvmPackages_20.libcxxClang
              (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
            ];
            RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
            LD_LIBRARY_PATH = lib.makeLibraryPath [
              llvmPackages_20.libllvm
              llvmPackages_20.clang-unwrapped
              llvmPackages_20.libcxxClang
            ];
          };
      }
    );
}
