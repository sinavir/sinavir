diff --git a/pkgs/applications/misc/tandoor-recipes/common.nix b/pkgs/applications/misc/tandoor-recipes/common.nix
index 8461ed816eb9..032158f1c6e0 100644
--- a/pkgs/applications/misc/tandoor-recipes/common.nix
+++ b/pkgs/applications/misc/tandoor-recipes/common.nix
@@ -1,15 +1,15 @@
 { lib, fetchFromGitHub }:
 rec {
-  version = "1.5.12";
+  version = "1.5.14";
 
   src = fetchFromGitHub {
     owner = "TandoorRecipes";
     repo = "recipes";
     rev = version;
-    hash = "sha256-5UslXRoiq9cipGCOiqpf+rv7OPTsW4qpVTjakNeg4ug=";
+    hash = "sha256-5KCyvM+ffpeovSdImH2NVyXb1U2dc43uw0kK/+LTdYE=";
   };
 
-  yarnHash = "sha256-CresovsRh+dLHGnv49fCi/i66QXOS3SnzfFNvkVUfd8=";
+  yarnHash = "sha256-7UBqIW5OUDZ6L+zexxNveX6W7GQvfxaGKpHH811Ffo4=";
 
   meta = with lib; {
     homepage = "https://tandoor.dev/";
diff --git a/pkgs/applications/misc/tandoor-recipes/default.nix b/pkgs/applications/misc/tandoor-recipes/default.nix
index dc36156ff4a1..37dcd796942b 100644
--- a/pkgs/applications/misc/tandoor-recipes/default.nix
+++ b/pkgs/applications/misc/tandoor-recipes/default.nix
@@ -31,15 +31,6 @@ python.pkgs.pythonPackages.buildPythonPackage rec {
 
   format = "other";
 
-  patches = [
-    # Allow setting MEDIA_ROOT through environment variable
-    # https://github.com/TandoorRecipes/recipes/pull/2931
-    (fetchpatch {
-      url = "https://github.com/TandoorRecipes/recipes/commit/abf981792057481f1d5b7473eb1090b3901ef8fa.patch";
-      hash = "sha256-3AFf0K/BpVwPQ2NGLUsefj6HvW7ej3szd3WaxFoqMiQ=";
-    })
-  ];
-
   propagatedBuildInputs = with python.pkgs; [
     beautifulsoup4
     bleach
@@ -50,7 +41,6 @@ python.pkgs.pythonPackages.buildPythonPackage rec {
     django-allauth
     django-annoying
     django-auth-ldap
-    django-autocomplete-light
     django-cleanup
     django-cors-headers
     django-crispy-forms
@@ -67,6 +57,7 @@ python.pkgs.pythonPackages.buildPythonPackage rec {
     djangorestframework
     drf-writable-nested
     gunicorn
+    homeassistant-api
     icalendar
     jinja2
     lxml
@@ -133,8 +124,12 @@ python.pkgs.pythonPackages.buildPythonPackage rec {
 
   nativeCheckInputs = with python.pkgs; [
     pytestCheckHook
+    pytest-asyncio
+    pytest-cov
     pytest-django
     pytest-factoryboy
+    pytest-html
+    mock
   ];
 
   # flaky
diff --git a/pkgs/development/python-modules/homeassistant-api/default.nix b/pkgs/development/python-modules/homeassistant-api/default.nix
new file mode 100644
index 000000000000..36533622622e
--- /dev/null
+++ b/pkgs/development/python-modules/homeassistant-api/default.nix
@@ -0,0 +1,67 @@
+{ lib
+, buildPythonPackage
+, fetchFromGitHub
+, poetry-core
+, aiohttp
+, aiohttp-client-cache
+, pydantic
+, requests
+, requests-cache
+, simplejson
+, pytestCheckHook
+, pytest-asyncio
+, pytest-cov
+, aiosqlite
+, pythonRelaxDepsHook
+}:
+
+buildPythonPackage rec {
+  pname = "homeassistant-api";
+  version = "4.2.1";
+  pyproject = true;
+
+  src = fetchFromGitHub {
+    owner = "GrandMoff100";
+    repo = "HomeAssistantAPI";
+    rev = "v${version}";
+    hash = "sha256-NbD2h8aCbqEoGXPNWaKmyakS3CYbR3gk5JbAw7GBnZQ=";
+  };
+
+  nativeBuildInputs = [
+    poetry-core
+    pythonRelaxDepsHook
+  ];
+
+  pythonRelaxDeps = [
+    "aiohttp-client-cache"
+    "requests-cache"
+  ];
+
+  nativeCheckInputs = [
+    pytestCheckHook
+    pytest-asyncio
+    pytest-cov
+    aiosqlite
+  ];
+
+  # Asking for a homeassistant server but we don't have one in the sandbox
+  doCheck = false;
+
+  propagatedBuildInputs = [
+    aiohttp
+    aiohttp-client-cache
+    pydantic
+    requests
+    requests-cache
+    simplejson
+  ];
+
+  pythonImportsCheck = [ "homeassistant_api" ];
+
+  meta = with lib; {
+    description = "Python Wrapper for Homeassistant's REST API";
+    homepage = "https://github.com/GrandMoff100/HomeAssistantAPI";
+    license = licenses.gpl3Only;
+    maintainers = with maintainers; [ ];
+  };
+}
diff --git a/pkgs/top-level/python-packages.nix b/pkgs/top-level/python-packages.nix
index 9258f8652160..7761ff1353ab 100644
--- a/pkgs/top-level/python-packages.nix
+++ b/pkgs/top-level/python-packages.nix
@@ -5295,6 +5295,8 @@ self: super: with self; {
 
   home-assistant-bluetooth = callPackage ../development/python-modules/home-assistant-bluetooth { };
 
+  homeassistant-api = callPackage ../development/python-modules/homeassistant-api { };
+
   homeassistant-bring-api = callPackage ../development/python-modules/homeassistant-bring-api { };
 
   home-assistant-chip-clusters = callPackage ../development/python-modules/home-assistant-chip-clusters { };
