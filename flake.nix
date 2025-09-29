{
  description = "My Extra Packages";

  inputs.trivnixLib.url = "github:Trivaris/TrivnixLib";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

  outputs =
    {
      trivnixLib,
      nixpkgs,
      self,
    }:
    let
      trivLib = trivnixLib.lib.for { selfArg = self; };
    in
    {
      packages.x86_64-linux =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.python
            ];
          };
        in
        {
          python313Packages = {
            inherit (pkgs.python313Packages) av adbutils;
          };
        };

      overlays =
        let
          mkDrvs =
            path:
            trivLib.resolveDir {
              dirPath = path;
              preset = "namePathMap";
            };

          mkAdditionOverlay =
            {
              drvs,
              pkgs,
              flakePath,
            }:
            let
              inherit (pkgs.lib) mapAttrs' nameValuePair;
            in
            mapAttrs' (
              name: path: (nameValuePair name (pkgs.callPackage ./${flakePath}/${path} { inherit pkgs; }))
            ) drvs;

          mkOverrideOverlay =
            {
              drvs,
              pkgs,
              flakePath,
              pkgPath ? "",
            }:
            let
              inherit (pkgs.lib) mapAttrs' nameValuePair;
            in
            mapAttrs' (
              name: path:
              (nameValuePair name (
                (pkgs.${pkgPath} or pkgs).${name}.overrideAttrs (_: import ./${flakePath}/${path} { inherit pkgs; })
              ))
            ) drvs;

          additionDrvs = mkDrvs ./additions;
          overrideDrvs = mkDrvs ./overrides;
          additionPyDrvs = mkDrvs ./python/additions;
          overridePyDrvs = mkDrvs ./python/overrides;
        in
        {
          default = final: prev: (self.overlays.additions final prev) // (self.overlays.overrides final prev);

          python =
            final: prev: {
              python313Packages =
                prev.python313Packages
                // (mkAdditionOverlay {
                  pkgs = prev;
                  drvs = additionPyDrvs;
                  flakePath = "python/additions";
                })
                // (mkOverrideOverlay {
                  pkgs = prev;
                  drvs = overridePyDrvs;
                  flakePath = "python/overrides";
                  pkgPath = "python313Packages";
                });
            };

          additions =
            _: pkgs:
            import ./modpacks.nix { inherit pkgs; }
            // mkAdditionOverlay {
              inherit pkgs;
              drvs = additionDrvs;
              flakePath = "additions";
            };

          overrides =
            _: pkgs:
            let
              inherit (pkgs.lib) mapAttrs' nameValuePair;
            in
            mapAttrs' (
              name: path:
              (nameValuePair name (pkgs.${name}.overrideAttrs (_: import ./overrides/${path} { inherit pkgs; })))
            ) overrideDrvs;

          pyAdditions = _: pkgs: {
            python313Packages =
              pkgs.python313Packages
              // (mkAdditionOverlay {
                inherit pkgs;
                drvs = additionPyDrvs;
                flakePath = "python/additions";
              });
          };

          pyOverrides = _: pkgs: {
            python313Packages =
              pkgs.python313Packages
              // (mkOverrideOverlay {
                inherit pkgs;
                drvs = overridePyDrvs;
                flakePath = "python/overrides";
                pkgPath = "python313Packages";
              });
          };
        };
    };
}
