{ lib
, buildPythonPackage
, setuptools
, setuptools-scm
, numpy
, zhinst-core
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "zhinst-utils";
  version = "23.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhinst";
    repo = "zhinst-utils";
    rev = "f6fb966cd2be56f6b67f93039b7a72bd62cfaff5";
    hash = "sha256-1fuX7F0yKx+CK9Cg9EktvEA8g0E+lZDanl6LOI86BjE=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    zhinst-core
  ];

  pythonImportsCheck = [ "zhinst.utils" ];

  meta = with lib; {
    description = "Intermediate Layer above the zhinst.core module that provides additional functions the ease the use of our instruments";
    homepage = "https://github.com/zhinst/zhinst-utils/tree/release-23.10";
    changelog = "https://github.com/zhinst/zhinst-utils/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "zhinst-utils";
  };
}
