{ pkgs, ... }:
let
  av = {
    version = "15.0.0";
    src = pkgs.fetchFromGithub {
      owner = "PyAV-Org";
      repo = "PyAV";
      tag = "v${av.version}";
      hash = "";
    };
  };
in
av
