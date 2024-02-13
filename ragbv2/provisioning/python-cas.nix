{ lib, requests, lxml, six, buildPythonPackage, fetchFromGitHub }:
buildPythonPackage rec {
  pname = "python-cas";
  version = "1.6.0";
  doCheck = false;
  src = fetchFromGitHub {
    owner = "python-cas";
    repo = "python-cas";
    rev = "v1.6.0";
    sha512 = "sha512-qnYzgwELUij2EdqA6H17q8vnNUsfI7DkbZSI8CCIGfXOM+cZ7vsWe7CJxzsDUw73sBPB4+zzpLxvb7tpm/IDeg==";
  };
  propagatedBuildInputs = [ requests lxml six ];
}
