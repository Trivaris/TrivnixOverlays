{ pkgs, ... }:
let
  adbutils = {
    pname = "adbutils";
    version = "2.10.2";
    format = "pyproject";
    doCheck = false;
    nativeBuildInputs = [ pkgs.python313Packages.pbr ];
    pythonImportsCheck = [ "adbutils" ];

    src = pkgs.fetchPypi {
      inherit (adbutils) pname version;
      sha256 = "sha256-NT0tTKbAt2tTxxfEHyyhDzzy0N5qpys+LS99oZvdxJU=";
    };

    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.python313Packages)
        requests
        deprecation
        retry2
        pillow
        ;
    };
  };
in
pkgs.python313Packages.buildPythonPackage adbutils
