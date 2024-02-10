{ lib
, python3
, fetchFromGitHub
, dotool
, vosk-api
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nerd-dictation";
  version = "unstable-2023-07-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ideasman42";
    repo = "nerd-dictation";
    rev = "1d52c1de7aa8360e77fd1ca1534b5ba3e143271a";
    hash = "sha256-g+q/JfcEwp09sXOGdi33iHDqzOEJq7KpCKKL5KD1AWc=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    vosk-api
  ];

  postInstall = ''
    wrapProgram $out/bin/nerd-dictation --suffix PATH ":" "${dotool}/bin/"
  '';

  meta = with lib; {
    description = "Simple, hackable offline speech to text - using the VOSK-API";
    homepage = "https://github.com/ideasman42/nerd-dictation";
    changelog = "https://github.com/ideasman42/nerd-dictation/blob/${src.rev}/changelog.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "nerd-dictation";
  };
}
