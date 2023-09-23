{ pyqt6,  buildPythonApplication, lib,  fetchPypi, packaging }:
buildPythonApplication rec {
  pname = "pyzo";
  version = "4.12.7";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-74tw7H+9aejbBFu5HpvKjfVlKZ0HLtFr436x9RHZXXw=";
  };
  
  propagatedBuildInputs = [ pyqt6 packaging ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://pyzo.org";
    description = "A python IDE";
    license = licenses.bsd2;
  };
}
