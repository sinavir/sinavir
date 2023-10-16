{ lib, fetchgit, pythoncas, django, ldap, buildPythonPackage }:
buildPythonPackage rec {
  pname = "authens";
  version = "v0.1b5";
  doCheck = false;
  src = fetchgit {
    url = "https://git.eleves.ens.fr/klub-dev-ens/authens.git";
    rev = "58747e57b30b47f36a0ed3e7c80850ed7f1edbf9";
    hash = "sha256-R0Nw212/BOPHfpspT5wzxtji1vxZ/JOuwr00naklWE8=";
  };
  propagatedBuildInputs = [ django ldap pythoncas ];
}
