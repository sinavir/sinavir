{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, cffi
, tqdm
, srt
, requests
, websockets
}:

buildPythonPackage rec {
  pname = "vosk-api";
  version = "0.3.45";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alphacep";
    repo = "vosk-api";
    rev = "v${version}";
    hash = "sha256-sa+rUJP0JvZo7YOFrWDEAuySlQJstOBnldz/LMiu/pk=";
  };
  sourceRoot = "source/python";

  VOSK_SOURCE = src;

  nativeBuildInputs = [
    setuptools
    wheel
    cffi
    requests
    tqdm
    srt
    websockets
  ];

  propagatedBuildInputs = [
    cffi
    requests
    tqdm
    srt
    websockets
  ];

  pythonImportsCheck = [ "vosk" ];

  meta = with lib; {
    description = "Offline speech recognition API for Android, iOS, Raspberry Pi and servers with Python, Java, C# and Node";
    homepage = "https://github.com/alphacep/vosk-api";
    #license = licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with maintainers; [ ];
  };
}
