{
  lib,
  stdenv,
  fetchurl,
  ...
}:
let
  millennium = {
    pname = "millennium";
    version = "v2.32.0";

    sourceRoot = ".";

    src = fetchurl {
      url = "https://github.com/SteamClientHomebrew/Millennium/releases/download/${millennium.version}/millennium-${millennium.version}-linux-x86_64.tar.gz";
      hash = "sha256-kjXaanWedEpj0EqzIdn5qZrmJrk6l/Fb13+W5aD5Jiw=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out

      # The tarball contains 'opt' and 'usr'.

      # Move 'opt' directly to $out/opt so it mounts at /opt in the container
      cp -r opt $out/

      # Move contents of 'usr' (lib, share) to $out/ so they mount at /usr/lib, etc.
      cp -r usr/* $out/

      runHook postInstall
    '';
  };
in
stdenv.mkDerivation millennium
