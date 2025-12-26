{
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  gcc,
  xorg,
  glibc,
  libGL,
  zlib,
  steam-run,
  stdenv,
  lib,
  ...
}:
let
  me3 = {
    pname = "me3";
    version = "v0.7.0";

    sourceRoot = ".";

    src = fetchurl {
      url = "https://github.com/garyttierney/me3/releases/download/${me3.version}/me3-linux-amd64.tar.gz";
      sha256 = "sha256-88WYgv82MShq35VgWaeBcmGJr6z5ktmlX73FcELRtXg=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [
      gcc.cc.lib
      xorg.libX11
      glibc
      libGL
      zlib
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/me3
      cp -r . $out/share/me3

      mkdir -p $out/bin

      # wrap with steam-run so Steam/Proton/sniper find GL & friends
      makeWrapper ${steam-run}/bin/steam-run $out/bin/me3 \
        --add-flags "$out/share/me3/bin/me3"

      # expose the helper launchers via steam-run as well
      for f in launch-*.sh; do
        makeWrapper ${steam-run}/bin/steam-run $out/bin/$f \
          --add-flags "$out/share/me3/$f"
      done
      runHook postInstall
    '';

    meta = {
      description = "A framework for modding and instrumenting games.";
      homepage = "https://https://github.com/garyttierney/me3";
      license = lib.licenses.mit;
    };
  };
in
stdenv.mkDerivation me3
