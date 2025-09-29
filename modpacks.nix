{ pkgs, ... }:
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
