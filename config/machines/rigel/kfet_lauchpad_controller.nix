{ lib
, buildPythonPackage
, fetchgit
, poetry
, lpminimk3
, python-osc
}:

buildPythonPackage rec {
  pname = "kfet-launchpad-controller";
  version = "unstable";
  pyproject = true;

  src = fetchgit {
    url = "https://git.soyouzpanda.fr/soyouzpanda/kfet_launchpad_controller.git";
    rev = "58f1086ca7a8a9258da7240987bf26c03182b152";
    hash = "sha256-c21BbRKK1AK6roIjdEg3zfMThyijRTK5Z87DBBBjoL0=";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    lpminimk3
    python-osc
  ];

  pythonImportsCheck = [ "eos_midi" ];

  meta = with lib; {
    description = "";
    homepage = "https://git.soyouzpanda.fr/soyouzpanda/kfet_launchpad_controller.git";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
