{
  description = "Additional Pkgs to be used in nix";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs =
    { self, nixpkgs }:
    {
      packages."x86_64-linux" =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
          inherit (pkgs.lib) mapAttrs' nameValuePair removeSuffix;
        in
        mapAttrs' (
          name: value: nameValuePair (removeSuffix ".nix" name) (pkgs.callPackage (./additions/${name}) { })
        ) (builtins.readDir ./additions);

      overlays.default = _: _: self.packages."x86_64-linux";
    };
}
