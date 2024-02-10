{ lib
, stdenv
, fetchFromGitHub
, cmake
, kaldi
, openblas
, openfst
}:

stdenv.mkDerivation rec {
  pname = "vosk";
  version = "0.3.45";

  src = fetchFromGitHub {
    owner = "alphacep";
    repo = "vosk-api";
    rev = "v${version}";
    hash = "sha256-sa+rUJP0JvZo7YOFrWDEAuySlQJstOBnldz/LMiu/pk=";
  };

  nativeBuildInputs = [
    cmake
    kaldi
    openblas
    openfst
  ];

  meta = with lib; {
    description = "Offline speech recognition API for Android, iOS, Raspberry Pi and servers with Python, Java, C# and Node";
    homepage = "https://github.com/alphacep/vosk-api";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "vosk";
    platforms = platforms.all;
  };
}
