{ lib
, stdenv
, coreutils
, stdenvNoCC
, fetchFromGitHub
, python311
, callPackage
, fetchzip
, uwsgi
, python311Packages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kitchenowl-backend";
  version = "93";

  src = fetchFromGitHub {
    owner = "TomBursch";
    repo = "kitchenowl-backend";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+6ENfrWAqHmu8J/JoAXl80ooxIAJs9RfWFHqI/Z/+Y8=";
  };

  buildPhase = ''
    echo "Adding pyhome to ini file"
    sed -i "16 a pyhome = ${finalAttrs.python}" wsgi.ini
    sed -i "17 a pythonpath = $out" wsgi.ini
    echo "patching wsgi file"
    substituteInPlace wsgi.ini --replace wsgi.py "$out/wsgi.py"
    '';

  installPhase = ''
    mkdir -p $out
    mv app templates migrations $out
    mv wsgi.ini wsgi.py manage.py upgrade_default_items.py $out
    '';

  passthru = {
    uwsgi = callPackage ./uwsgi {
      plugins = [ "gevent" "python3" ];
      python3 = finalAttrs.python;
    };
    nltk_data = stdenvNoCC.mkDerivation (finalAttrs: {
      name = "nltk-data-for-kitchenowl";
      src = fetchzip {
        url = "https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/taggers/averaged_perceptron_tagger.zip";
        hash = "sha256-RBcFxETVjfF5VGiQ8P2Yy4HpAsIE8R50d9xJ3DW0aqA=";
      };
      buildPhase = ''
        OUT_DIR="$out/taggers/averaged_perceptron_tagger"
        mkdir -p "$OUT_DIR"
        mv * "$OUT_DIR"
      '';
    });
  };
  python = python311.withPackages (ps: let
    callPackage = ps.callPackage;
  in [
    ps.alembic
    ps.amqp
    ps.annotated-types
    ps.apispec
    ps.appdirs
    ps.apscheduler
    ps.attrs
    ps.autopep8
    ps.bcrypt
    ps.beautifulsoup4
    ps.bidict
    ps.billiard
    ps.black
    ps.blinker
    ps.blurhash
    ps.celery
    ps.certifi
    ps.cffi
    ps.charset-normalizer
    ps.click
    ps.click-didyoumean
    ps.click-plugins
    ps.click-repl
    ps.contourpy
    ps.cryptography
    ps.cycler
    (callPackage ./dbscan1d.nix {})
    ps.defusedxml
    ps.extruct
    ps.flake8
    ps.flask
    (callPackage ./flask-apscheduler.nix {})
    ps.flask-basicauth
    ps.flask-bcrypt
    ps.flask-jwt-extended
    ps.flask-migrate
    ps.flask-socketio
    ps.flask-sqlalchemy
    ps.fonttools
    ps.future
    ps.gevent
    ps.greenlet
    ps.h11
    ps.html-text
    ps.html5lib
    ps.idna
    (callPackage ./ingredient-parser-nlp.nix {})
    ps.iniconfig
    ps.isodate
    ps.itsdangerous
    ps.jinja2
    ps.joblib
    ps.jstyleson
    ps.kiwisolver
    ps.kombu
    ps.lark
    ps.lxml
    ps.mako
    ps.markupsafe
    ps.marshmallow
    ps.matplotlib
    ps.mccabe
    ps.mf2py
    (callPackage ./mlxtend.nix {})
    ps.mypy-extensions
    ps.nltk
    ps.numpy
    (callPackage ./oic.nix {})
    ps.packaging
    ps.pandas
    ps.pathspec
    ps.pillow
    ps.platformdirs
    ps.pluggy
    ps.prometheus-client
    ps.prometheus-flask-exporter
    ps.prompt-toolkit
    ps.psycopg2
    ps.py
    ps.pycodestyle
    ps.pycparser
    ps.pycryptodomex
    ps.pydantic
    # pydantic-core -> already included by pydantic
    ps.pyflakes
    ps.pyjwkest
    ps.pyjwt
    ps.pyparsing
    ps.pyrdfa3
    ps.pytest
    ps.python-crfsuite
    ps.python-dateutil
    ps.python-dotenv
    ps.python-editor
    ps.python-engineio
    ps.python-socketio
    ps.pytz
    ps.pytz-deprecation-shim
    ps.rdflib
    #ps.rdflib-jsonld -> No need since it is now integrated to rdflib
    ps.recipe-scrapers
    ps.regex
    ps.requests
    ps.scikit-learn
    ps.scipy
    ps.setuptools-scm
    ps.simple-websocket
    ps.six
    ps.soupsieve
    ps.sqlalchemy
    (callPackage ./sqlite-icu.nix {})
    ps.threadpoolctl
    ps.toml
    ps.tomli
    ps.tqdm
    ps.typed-ast
    ps.types-beautifulsoup4
    ps.types-html5lib
    ps.types-requests
    ps.types-urllib3
    ps.typing-extensions
    ps.tzdata
    ps.tzlocal
    ps.urllib3
    ps.w3lib
    ps.wcwidth
    ps.webencodings
    ps.werkzeug
    ps.wsproto
    ps.zope_event
    ps.zope_interface

  ]);

  meta = with lib; {
    description = "Backend for the KitchenOwl app";
    homepage = "https://github.com/TomBursch/kitchenowl-backend";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
  };
})
