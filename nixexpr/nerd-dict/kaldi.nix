{ lib
, git
, wget
, stdenv
, gfortran
, openblas
, blas
, sox
, lapack
, icu
, pkg-config
, fetchFromGitHub
, python3
, autoconf
, writeShellScript
, breakpointHook
, zlib
, openfst
, unzip
, automake
, gettext
, libtool
}:

assert blas.implementation == "openblas" && lapack.implementation == "openblas";
stdenv.mkDerivation (finalAttrs: {
  pname = "kaldi";
  version = "unstable-2023-11-13";

  src = fetchFromGitHub {
    owner = "alphacep";
    repo = "kaldi";
    rev = "2b69aed630e26fb2c700bba8c45f3bd012371c5c";
    hash = "sha256-rHDN71y0Dxv7nTYRGjPCiD9Otzf2EMKUgUJ7BisP3Rk=";
  };

  #cmakeFlags = [
  #  "-DKALDI_BUILD_TEST=off"
  #  "-DBUILD_SHARED_LIBS=on"
  #  "-DBLAS_LIBRARIES=-lblas"
  #  "-DLAPACK_LIBRARIES=-llapack"
  #  "-DFETCHCONTENT_SOURCE_DIR_OPENFST:PATH=${finalAttrs.passthru.sources.openfst}"
  #];

  buildInputs = [
    zlib
    unzip
    sox
    openblas
    icu
  ];

  OPENBLASROOT = builtins.toString openblas.dev;

  nativeBuildInputs = [
    wget
    git
    gfortran
    pkg-config
    breakpointHook
    python3
    autoconf
 automake gettext libtool
  ];

  OPENFST_VERSION = "1.8.0";
  CUB_VERSION = "1.8.0";

  preBuild = ''
    patchShebangs --host ./tools/extras/check_dependencies.sh
    patchShebangs --host ./src/configure
    pushd ./tools
    cp -r --no-preserve=mode,ownership ${finalAttrs.passthru.sources.openfst} openfst-$OPENFST_VERSION
    ln -s ${finalAttrs.passthru.sources.cub} cub
    touch -t 197001010000 cub-${finalAttrs.CUB_VERSION}.tar.gz
    popd
    '';

  buildPhase = ''
    runHook preBuild
    cd tools
    make -j $NIX_BUILD_CORES cub
    make -j $NIX_BUILD_CORES openfst
    cd ../src
    ./configure --mathlib=OPENBLAS_CLAPACK --shared
    make -j $NIX_BUILD_CORES online2 lm rnnlm
  '';

  postInstall = ''
    mkdir -p $out/share/kaldi
    cp -r ../egs $out/share/kaldi
  '';

  passthru = {

    sources.openfst = fetchFromGitHub {
      owner = "alphacep";
      repo = "openfst";
      rev = "7dfd808194105162f20084bb4d8e4ee4b65266d5";
      hash = "sha256-XiPR4AaSa/7OqYoYZOwlW3UhAsYmscBE36xffI2gPPg=";
    };

    sources.cub = fetchFromGitHub {
      owner = "NVlabs";
      repo = "cub";
      rev = finalAttrs.CUB_VERSION;
      hash = "sha256-j52BSkTItExznQApZbv868ipU4SCAu0EOqljzzKnIdk=";
    };

  };

  meta = with lib; {
    description = "Speech Recognition Toolkit";
    homepage = "https://kaldi-asr.org";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
})
