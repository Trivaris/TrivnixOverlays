{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forEachSystem =
        f:
        builtins.listToAttrs (
          map (system: {
            name = system;
            value = f (import nixpkgs { inherit system; });
          }) systems
        );

      getPkgs = pkgs: path:
        pkgs.lib.pipe (builtins.readDir path) [
          (pkgs.lib.filterAttrs (name: type: type == "regular" && pkgs.lib.hasSuffix ".nix" name))
          builtins.attrNames
          (map (filename: {
            name = pkgs.lib.removeSuffix ".nix" filename;
            value = pkgs.callPackage "${path}/${filename}" { };
          }))
          builtins.listToAttrs
        ];
    in
    {
      packages = forEachSystem (
        pkgs: getPkgs pkgs ./additions
      );

      overlays.default = final: prev:
        getPkgs final ./additions;
    };
}
