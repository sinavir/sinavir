{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "drawsvg";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cduck";
    repo = "drawsvg";
    rev = version;
    hash = "sha256-LoA5yYeHO4GqS3dk7EMg1ZC42HBgmM6rSfigWMc4yUQ=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "drawsvg" ];

  meta = with lib; {
    description = "Programmatically generate SVG (vector) images, animations, and interactive Jupyter widgets";
    homepage = "https://github.com/cduck/drawsvg";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
