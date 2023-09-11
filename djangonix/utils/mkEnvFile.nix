{
  pkgs,
  lib,
}: {
  envPrefix,
  settings,
  app,
}: let
  env = let
    # make env file to source before using manage.py and other commands
    mkVarVal = v: let
      isHasAttr = s: lib.isAttrs v && lib.hasAttr s v;
    in
      if builtins.isString v || builtins.isPath v
      then "\"${v}\""
      else if builtins.isList v && lib.any lib.strings.isCoercibleToString v
      then "\"" + (lib.concatMapStringsSep "," builtins.toString v) + "\""
      else if builtins.isInt v
      then toString v
      else if builtins.isBool v
      then
        toString (
          if v
          then 1
          else 0
        )
      else if isHasAttr "_file"
      then "\"$(cat ${v._file} | xargs)\""
      else if isHasAttr "_raw"
      then v._raw
      else abort "The django conf value ${lib.generators.toPretty {} v} can not be encoded.";
  in
    lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "export ${envPrefix}${k}=${mkVarVal v}") settings);
in
  pkgs.writeScript "django-${app}-env.sh" env
