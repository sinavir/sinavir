{ lib
, python3
, fetchFromGitHub
, buildPythonPackage 
, flask
, apscheduler
, python-dateutil
}:

buildPythonPackage rec {
  pname = "flask-apscheduler";
  version = "1.13.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "viniciuschiele";
    repo = "flask-apscheduler";
    rev = version;
    hash = "sha256-0gZueUuBBpKGWE6OCJiJL/EEIMqCVc3hgLKwIWFuSZI=";
  };

  propagatedBuildInputs = [
    apscheduler
    flask
    python-dateutil
  ];

  pythonImportsCheck = [ "flask_apscheduler" ];

  meta = with lib; {
    description = "Adds APScheduler support to Flask";
    homepage = "https://github.com/viniciuschiele/flask-apscheduler";
    changelog = "https://github.com/viniciuschiele/flask-apscheduler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
