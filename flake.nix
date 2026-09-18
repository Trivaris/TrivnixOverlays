{
  description = "Additional Pkgs to be used in nix";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.qml-lsp.url = "github:cushycush/qml-language-server";

  outputs =
    { self, nixpkgs, qml-lsp }:
    {
      packages."x86_64-linux" =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
          inherit (pkgs.lib) mapAttrs' nameValuePair removeSuffix;
        in
        { qml-lsp = qml-lsp.packages."x86_64-linux".default; } // (mapAttrs' (
          name: value: nameValuePair (removeSuffix ".nix" name) (pkgs.callPackage ./additions/${name} { })
        ) (builtins.readDir ./additions));

      overlays.default = _: _: self.packages."x86_64-linux";
    };
}
