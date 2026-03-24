{
  appimageTools,
  fetchurl,
  ...
}:
appimageTools.wrapType2 {
  pname = "R2Modman";
  version = "3.2.14";
  src = fetchurl {
    url = "https://github.com/ebkr/r2modmanPlus/releases/download/v3.2.14/r2modman-3.2.14.AppImage";
    hash = "sha256-KjKAzVyQgG8kXfhNmw8VfRco1pVhi3yGA81L+m1narU=";
  };
}