{ lib
, buildPythonPackage
, fetchgit
, poetry-core
, lpminimk3
, python-osc
}:

buildPythonPackage rec {
  pname = "kfet-launchpad-controller";
  version = "unstable";
  pyproject = true;

  src = fetchgit {
    url = "https://git.soyouzpanda.fr/soyouzpanda/kfet_launchpad_controller";
    rev = "6d7df83cfd2f558d4837474ea101f98439a4f8c5";
    hash = "sha256-HkaR1+9NxvyRQ3+iP6pq3Wn6QT+qQRFJBvxHNH6qM0k=";
  };

  patches = [ ./launchpad.patch ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    lpminimk3
    python-osc
  ];

  pythonImportsCheck = [ "eos_midi" ];

  meta = with lib; {
    description = "";
    homepage = "https://git.soyouzpanda.fr/soyouzpanda/kfet_launchpad_controller";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
