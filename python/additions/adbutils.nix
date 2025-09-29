{ pkgs, ... }:
let
  adbutils-src = {
    pname = "adbutils";
    version = "2.10.2";
    format = "pyproject";
    doCheck = false;
    nativeBuildInputs = [ pkgs.pbr ];
    pythonImportsCheck = [ "adbutils" ];

    src = pkgs.fetchPypi {
      inherit (adbutils-src) pname version;
      sha256 = "sha256-NT0tTKbAt2tTxxfEHyyhDzzy0N5qpys+LS99oZvdxJU=";
    };

    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs)
        requests
        deprecation
        retry2
        pillow
        ;
    };
  };
in
pkgs.buildPythonPackage adbutils-src
