{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, wheel
, black
, isort
, jsonref
, jsonschema
, numpy
, pre-commit
, pyelftools
, pytest
, typing-extensions
, zhinst-core
, zhinst-utils
}:

buildPythonPackage rec {
  pname = "zhinst-toolkit";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhinst";
    repo = "zhinst-toolkit";
    rev = "v${version}";
    hash = "sha256-IO39scCdQ/mFtwDdjDK+63EBVq6+qQMKMXX+s6Ml3aU=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    jsonref
    jsonschema
    numpy
    pyelftools
    zhinst-core
    zhinst-utils
    typing-extensions
  ];

  pythonImportsCheck = [ "zhinst.toolkit" ];

  meta = with lib; {
    description = "Generic high-level interfaces for Zurich Instruments devices";
    homepage = "https://github.com/zhinst/zhinst-toolkit";
    changelog = "https://github.com/zhinst/zhinst-toolkit/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
