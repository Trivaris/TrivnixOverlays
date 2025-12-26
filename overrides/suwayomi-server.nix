{
  jdk21_headless,
  makeWrapper,
  fetchurl,
  ...
}:
let
  jdk = jdk21_headless;
  suwayomi-server = {
    revision = null;
    version = "v2.0.1854";

    nativeBuildInputs = [ makeWrapper ];
    dontUnpack = true;

    src = fetchurl {
      url = "https://github.com/Suwayomi/Suwayomi-Server-preview/releases/download/${suwayomi-server.version}/Suwayomi-Server-${suwayomi-server.version}.jar";
      hash = "sha256-oDE0b77qxTovZTd+P9J01wNxYZ3BrNqoX03biei03pM=";
    };

    buildPhase = ''
      runHook preBuild

      makeWrapper ${jdk}/bin/java $out/bin/tachidesk-server \
        --add-flags "-Dsuwayomi.tachidesk.config.server.initialOpenInBrowserEnabled=false -jar $src"

      runHook postBuild
    '';
  };
in
suwayomi-server
