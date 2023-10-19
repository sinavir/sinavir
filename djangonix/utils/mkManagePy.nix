{writeShellApplication}: {
  app,
  pythonPackage,
  envPrefix,
  manageFilePath,
  src,
  envFile,
}:
{
  managePy = writeShellApplication {
    name = "manage-${app}";
    runtimeInputs = [pythonPackage];
    text = ''
      # shellcheck disable=SC1091
      source ${envFile}
      python ${src}/${manageFilePath} "$@"
    '';
  };

  collectstatic = writeShellApplication {
    name = "collectstatic";
    runtimeInputs = [pythonPackage];
    text = ''
      export ${envPrefix}SECRET_KEY="collectstatic"
      export ${envPrefix}STATIC_ROOT="$1"
      export ${envPrefix}DEBUG=0
      export ${envPrefix}ALLOWED_HOSTS=
      export ${envPrefix}DB_FILE=
      python ${src}/${manageFilePath} collectstatic
    '';
  };
}
