{
  rustPlatform,
  ncurses5,
  fetchFromGitHub,
  lib,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "rbonsai";
  version = "0.1.5";

  nativeBuildInputs = [ ncurses5.dev ];
  buildInputs = [ ncurses5 ];
  cargoHash = "sha256-78vOnu5RZgIR71x8fXbWmoeRDzRgaZBQXJ6nugLNij0=";

  src = fetchFromGitHub {
    owner = "roberte777";
    repo = "rbonsai";
    rev = "368d0a28c347510a6db909f8019c47d459746e84";
    sha256 = "sha256-69MArXaMZLchKURM0koLACKWhm3NO+ZVoZsiHt9PkjQ=";
  };

  meta = {
    description = "A terminal bonsai tree generator";
    homepage = "https://github.com/roberte777/rbonsai";
    license = lib.licenses.gpl3Plus;
  };
}
