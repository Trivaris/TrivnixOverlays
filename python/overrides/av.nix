{ pkgs, ... }:
let 
  av = {
    version = "15.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "PyAV-Org";
      repo = "PyAV";
      rev = "v${av.version}";
      hash = "sha256-VeF6Sti1Ide2LchiCuPut/bdbJUv+5eTH2q0YMcniyA=";
    };

    preCheck =
      let
        # keep a local, deterministic cache of the samples required by the test-suite
        testSamples = pkgs.linkFarm "pyav-test-samples" (
          pkgs.lib.mapAttrs (_: pkgs.fetchurl) (pkgs.lib.importTOML ./test-samples.toml)
        );
      in
      ''
        # force pytest to import the compiled extension from site-packages
        rm -rf av
        ln -s ${testSamples} tests/assets
      '';
  };
in 
av