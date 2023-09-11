{writeShellApplication}: {
  app,
  pythonPackage,
  envPrefix,
  manageFilePath,
  src,
  envFile,
}:
writeShellApplication {
  name = "manage-${app}";
  passthru = {
    collectstatic = writeShellApplication {
      name = "collectstatic";
      runtimeInputs = [pythonPackage];
      text = ''
        export ${envPrefix}SECRET_KEY="collectstatic"
        export ${envPrefix}STATIC_ROOT="$1"
        export ${envPrefix}DEBUG=0
        export ${envPrefix}ALLOWED_HOSTS=
        export ${envPrefix}DB_FILE=
        python ${manageFilePath} collectstatic
      '';
    };
  };
  runtimeInputs = [pythonPackage];
  text = ''
    source ${envFile}
    python ${src}/${manageFilePath} $@
  '';
}
