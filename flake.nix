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

      getPkgs =
        pkgs: lib: path:
        lib.pipe (builtins.readDir path) [
          (lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name))
          builtins.attrNames
          (map (filename: {
            name = lib.removeSuffix ".nix" filename;
            value = pkgs.callPackage (path + "/${filename}") { };
          }))
          builtins.listToAttrs
        ];
    in
    {
      packages = forEachSystem (pkgs: getPkgs pkgs pkgs.lib ./additions);

      overlays.default = final: prev: getPkgs final prev.lib ./additions;
    };
}
