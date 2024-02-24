{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, flask
}:

buildPythonPackage rec {
  pname = "flask-basicauth";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpvanhal";
    repo = "flask-basicauth";
    rev = "v${version}";
    hash = "sha256-han0OjMI1XmuWKHGVpk+xZB+/+cpV1I+659zOG3hcPY=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    flask
  ];

  pythonImportsCheck = [ "flask_basicauth" ];

  meta = with lib; {
    description = "HTTP basic access authentication for Flask";
    homepage = "https://github.com/jpvanhal/flask-basicauth";
    changelog = "https://github.com/jpvanhal/flask-basicauth/blob/${src.rev}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
