{ pkgs, ... }:
let
  av = {
    pname = "av";
    version = "15.1.0";
    pyproject = true;

    disabled = pkgs.python313Packages.pythonOlder "3.9";

    src = pkgs.fetchFromGitHub {
      owner = "PyAV-Org";
      repo = "PyAV";
      rev = "v${av.version}";
      hash = "sha256-VeF6Sti1Ide2LchiCuPut/bdbJUv+5eTH2q0YMcniyA=";
    };

    build-system = [
      pkgs.python313Packages.cython
      pkgs.python313Packages.setuptools
    ];

    nativeBuildInputs = [ pkgs.pkg-config ];

    buildInputs = [ pkgs.ffmpeg-headless ];

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

    nativeCheckInputs = [
      pkgs.python313Packages.numpy
      pkgs.python313Packages.pillow
      pkgs.python313Packages.pytestCheckHook
    ];

    # `__darwinAllowLocalNetworking` doesn’t work for these; not sure why.
    disabledTestPaths = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      "tests/test_timeout.py"
    ];

    pythonImportsCheck = [
      "av"
      "av.audio"
      "av.buffer"
      "av.bytesource"
      "av.codec"
      "av.container"
      "av._core"
      "av.datasets"
      "av.descriptor"
      "av.dictionary"
      "av.error"
      "av.filter"
      "av.format"
      "av.frame"
      "av.logging"
      "av.option"
      "av.packet"
      "av.plane"
      "av.stream"
      "av.subtitles"
      "av.utils"
      "av.video"
    ];

    meta = {
      description = "Pythonic bindings for FFmpeg";
      mainProgram = "pyav";
      homepage = "https://github.com/PyAV-Org/PyAV";
      changelog = "https://github.com/PyAV-Org/PyAV/blob/v${av.version}/CHANGELOG.rst";
      license = pkgs.lib.licenses.bsd2;
      maintainers = [ ];
    };
  };
in
pkgs.python313Packages.buildPythonPackage av
