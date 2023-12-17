{ lib
, buildPythonApplication
, retropieSetup
, hatchling
, pysdl2
}:

buildPythonApplication {
  pname = "joykeyd";
  version = "4.8";
  pyproject = true;


  unpackPhase = ''
    mkdir source
    cp ${./pyproject.toml} source/pyproject.toml
    cp ${retropieSetup}/scriptmodules/admin/joy2key/joy2key_sdl.py source/
    cp ${retropieSetup}/LICENSE.md source/
    cd source
  '';

  patchPhase = ''
    substituteAllInPlace pyproject.toml
    substituteInPlace joy2key_sdl.py --replace "CONFIG_DIR = '/opt/retropie/configs'" $'import os\nCONFIG_DIR = os.getenv("JOY2KEY_CONFIG_DIR", "/etc/joy2key")'
    #TODO provide default config files
    #TODO finer config (JS_CFG_DIR and RETROARCH_CONFIG)
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pysdl2
  ];
}
