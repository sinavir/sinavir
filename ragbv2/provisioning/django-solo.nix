{ lib
, buildPythonPackage
, django
, setuptools
, wheel
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "django-solo";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lazybird";
    repo = "django-solo";
    rev = version;
    hash = "sha256-4+y9mRMLqIm2Jev+ieTlUhSwWQ6HgEpQCpUNVuNMGB0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  buildInputs = [
    django
  ];

  pythonImportsCheck = [ "solo" ];

  meta = with lib; {
    description = "Helps working with singletons - things like global settings that you want to edit from the admin site";
    homepage = "https://github.com/lazybird/django-solo";
    changelog = "https://github.com/lazybird/django-solo/blob/${src.rev}/CHANGES";
    #license = licenses.unfree;
    maintainers = with maintainers; [ ];
    mainProgram = "django-solo";
  };
}
