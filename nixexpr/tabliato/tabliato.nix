{ lib
, stdenv
, fetchFromGitHub
, freepats
, libsForQt5
, lilypond
, qmake
, qtbase
, qtmultimedia
, timidity
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "tabliato";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "Jean-Romain";
    repo = "tabliato";
    rev = "v${version}";
    hash = "sha256-qGJSxYYpYHcKPmJekXErXjnF9AegP5UFDWNZWN4OeMo=";
  };

  patches = [
    ./remove_accent.patch
  ];

  postPatch = ''
    substituteInPlace ./tabliato.pro --replace "/usr/include/poppler/qt5" "${libsForQt5.poppler.dev}/include/poppler/qt5"
    mv "ressources/exemples/Polka piquée.dtb" "ressources/exemples/Polka piquee.dtb"
    '';

  buildInputs = [
    freepats
    libsForQt5.poppler.dev
    lilypond
    qmake
    qtbase
    qtmultimedia
    timidity
  ];
  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  qtWrapperArgs = [
    ''--prefix PATH : ${lilypond}/bin''
    ''--prefix PATH : ${timidity}/bin''
  ];

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/share/icons/
    mkdir -p $out/share/applications/
    mkdir -p $out/share/app-install/icons/
    cp ./debian/tabliato.desktop $out/share/applications/
    cp ./tabliato $out/bin/
    cp ./ressources/icons/tabliato.svg $out/share/app-install/icons/
    cp ./ressources/icons/tabliato.svg $out/share/icons/
    rm -rf tabliato/usr/share/tabliato
  '';

  meta = with lib; {
    description = "Tablatures pour accordéon diatonique :musical_note";
    homepage = "https://github.com/Jean-Romain/tabliato";
    changelog = "https://github.com/Jean-Romain/tabliato/blob/${src.rev}/Changelog.md";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
