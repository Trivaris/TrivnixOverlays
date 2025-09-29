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
          mkDrvs =
            path:
            trivLib.resolveDir {
              dirPath = path;
              preset = "namePathMap";
            };

          additionDrvs = mkDrvs ./additions;
          overrideDrvs = mkDrvs ./overrides;
          additionPyDrvs = mkDrvs ./python/additions;
          overridePyDrvs = mkDrvs ./python.overrides;
        in
        {
          default = final: prev: (self.overlays.additions final prev) // (self.overlays.overrides final prev);

          python =
            final: prev: (self.overlays.pyAddtions final prev) // (self.overlays.pyOverrides final prev);

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
              name: path: (nameValuePair name (pkgs.callPackage ./additions/${path} { inherit pkgs; }))
            ) additionDrvs);

          overrides =
            _: pkgs:
            let
              inherit (pkgs.lib) mapAttrs' nameValuePair;
            in
            mapAttrs' (
              name: path:
              (nameValuePair name (pkgs.${name}.overrideAttrs (_: import ./overrides/${path} { inherit pkgs; })))
            ) overrideDrvs;

          pyAddtions =
            _: pkgs:
            let
              inherit (pkgs.lib) mapAttrs' nameValuePair;
            in
            {
              python13Packages =
                pkgs.python13Packages
                // (mapAttrs' (
                  name: path: (nameValuePair name (pkgs.callPackage ./python/additions/${path} { inherit pkgs; }))
                ) additionPyDrvs);
            };

          pyOverrides =
            _: pkgs:
            let
              inherit (pkgs.lib) mapAttrs' nameValuePair;
            in
            {
              python13Packages =
                pkgs.python13Packages
                // (mapAttrs' (
                  name: path:
                  (nameValuePair name (
                    pkgs.python13Packages.${name}.overrideAttrs (_: import ./python/overrides/${path} { inherit pkgs; })
                  ))
                ) overridePyDrvs);
            };
        };
    };
}
