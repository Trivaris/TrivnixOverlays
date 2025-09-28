{
  description = "My Extra Packages";

  inputs.trivnixLib.url = "github:Trivaris/TrivnixLib";

  outputs =
    { trivnixLib, self }:
    let
      trivLib = trivnixLib.lib.for { selfArg = self; };
    in
    {
      overlays =
        let
          extraPkgs = trivLib.resolveDir {
            dirPath = ./packages;
            preset = "namePathMap";
          };

          extraOverrides = trivLib.resolveDir {
            dirPath = ./overrides;
            preset = "namePathMap";
          };
        in
        {
          default =
            final: prev: (self.overlays.additions final prev) // (self.overlays.modifications final prev);

          additions =
            _: pkgs:
            let
              inherit (pkgs.lib) mapAttrs' nameValuePair;
            in
            {
              modpacks = {
                elysiumDays = pkgs.callPackage ./mkModpack.nix {
                  inherit pkgs;
                  modrinthUrl = "https://cdn.modrinth.com/data/lz3ryGPQ/versions/azCePsLz/Elysium%20Days%207.0.0.mrpack";
                  hash = "sha256-/1xIPjUSV+9uPU8wBOr5hJ3rHb2V8RkdSdhzLr/ZJ2Y=";
                };

                risingLegends = pkgs.callPackage ./mkModpack.nix {
                  inherit pkgs;
                  modrinthUrl = "https://cdn.modrinth.com/data/Qx4KOI2G/versions/SVpfGIfp/Rising%20Legends%202.2.0.mrpack";
                  hash = "sha256-kCMJ6PUSaVr5Tpa9gFbBOE80kUQ4BaNLE1ZVzTfqTFM=";
                };
              };
            }
            // (mapAttrs' (
              name: path: (nameValuePair name (pkgs.callPackage ./packages/${path} { inherit pkgs; }))
            ) extraPkgs);

          modifications =
            _: pkgs:
            let
              inherit (pkgs.lib) mapAttrs' nameValuePair;
            in
            mapAttrs' (
              name: path:
              (nameValuePair name (pkgs.${name}.overrideAttrs (_: import ./overrides/${path} { inherit pkgs; })))
            ) extraOverrides;
        };
    };
}
