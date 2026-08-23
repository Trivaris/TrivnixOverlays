{
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "quartz";
  version = "v5";
  src = fetchFromGitHub {
    owner = "jackyzha0";
    repo = "quartz";
    
    src = "https://github.com/jackyzha0/quartz.git";
  };

  nativeBuildInputs = [ ];

  installPhase = ''
  '';
})