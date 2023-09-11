{runCommand}: {
  managePy,
  source,
  app,
  envPrefix ? "",
}:
runCommand "django-${app}-static" {} ''
  mkdir -p $out
  export ${envPrefix}SECRET_KEY="collectstatic"
  export ${envPrefix}STATIC_ROOT=$out
  export ${envPrefix}DEBUG=0
  export ${envPrefix}ALLOWED_HOSTS=
  export ${envPrefix}DB_FILE=
  ${python}/bin/python ${source}/${app}/manage.py collectstatic
''
