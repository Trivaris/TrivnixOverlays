{
  fetchurl,
  stdenv,
  makeWrapper,
  lib,
  jdk21,
  libGL,
  glib,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "JTegraNX";
  version = "1.7.0";

  src = fetchurl {
    url = "https://github.com/DefenderOfHyrule/JTegraNX/releases/download/1.7.0/JTegraNX-1.7.0.jar";
    sha256 = "sha256:2d6ee352bf7a277289f370d09cb16ea97916d426b47a5f9ebb712f4ac08c9328";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libGL glib ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java
    mkdir -p $out/etc/udev/rules.d

    cp $src $out/share/java/JTegraNX.jar

    makeWrapper ${jdk21}/bin/java $out/bin/JTegraNX \
      --add-flags "-jar $out/share/java/JTegraNX.jar" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL glib ]}"

    echo 'SUBSYSTEMS=="usb", ATTRS{manufacturer}=="NVIDIA Corp.", ATTRS{product}=="APX", GROUP="nintendo_switch", TAG+="uaccess"' > $out/etc/udev/rules.d/99-jtegranx.rules
  '';
})