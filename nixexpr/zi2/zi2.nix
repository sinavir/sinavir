{ lib
, stdenv
, buildPythonApplication
, fetchFromGitHub
, numpy
, zhinst-core
, zhinst-utils
, zhinst-toolkit
, matplotlib
, pillow
, gwyfile
}:

buildPythonApplication rec {
  pname = "zi2";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "UnlikelyBuddy1";
    repo = "ZI2";
    rev = "master";
    hash = "sha256-7e8xmmnIiEqHavNJXHe1Lfne/5eSP8uQrL+IesQAckM=";
  };

  propagatedBuildInputs = [
    numpy
    zhinst-core
    zhinst-utils
    zhinst-toolkit
    matplotlib
    pillow
    gwyfile
  ];



  meta = with lib; {
    description = "Plot of internal demod data streams of HF2LI during AFM scan (Synchronized with Nanoscope V";
    homepage = "https://github.com/UnlikelyBuddy1/ZI2";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ ];
    mainProgram = "zi2";
    platforms = platforms.all;
  };
}
