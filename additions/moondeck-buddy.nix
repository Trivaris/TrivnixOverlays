{
  fetchurl,
  appimageTools,
  ...
}:
let 
  pname = "moondeck-buddy";
  version = "1.9.2";
  src = fetchurl {
    url = "https://github.com/FrogTheFrog/moondeck-buddy/releases/download/v${version}/MoonDeckBuddy-${version}-x86_64.AppImage";
    sha256 = "";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraPackages = pkgs: [ ];
}
