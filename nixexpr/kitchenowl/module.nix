{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  options = {
    services.kitchenowl = {
      enable = lib.mkEnableOption "kitchenowl";
      secretKeyPath = lib.mkOption {
        description = "secret-key path";
      };
    };
  };
  config = {
    systemd.services = {
      kitchenowl = {
        description = "Kitchen-owl service";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        serviceConfig = {
          DynamicUser = true;
        };
        path = [
          pkgs.kitchenowlBackend.python
          pkgs.uwsgi
        ];
        environment = {
          NLTK_DATA = pkgs.kitchenowlBackend.nltk_data;
          #PRIVACY_POLICY_URL = "sinavir.fr";
          OPEN_REGISTRATION = "False";
          EMAIL_MANDATORY = "False";
          COLLECT_METRICS = "False";
          DB_DRIVER = "sqlite";
          FLASK_APP = "${pkgs.kitchenowlBackend}/app";
          DEBUG="False";
          # DB_NAME -> default name is good
        };
        serviceConfig = {
          StateDirectory = "kitchenowl";
          LoadCredential = [
            "secretkey:${config.services.kitchenowl.secretKeyPath}"
          ];
        };
        script = ''
          export STORAGE_PATH=$STATE_DIRECTORY
          export JWT_SECRET_KEY=$(cat $CREDENTIALS_DIRECTORY/secretkey)

          echo "Make upload directory"
          mkdir -p "$STORAGE_PATH/upload"
          echo "Flask db upgrade"
          flask db upgrade --directory "${pkgs.kitchenowlBackend}/migrations"
          echo "Upgrade default items"
          python ${pkgs.kitchenowlBackend}/upgrade_default_items.py
          echo "Running"
          ${pkgs.kitchenowlBackend.uwsgi}/bin/uwsgi --plugin python3 --plugin gevent --gevent 200 ${pkgs.kitchenowlBackend}/wsgi.ini
        '';
      };
    };
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "manage-kitchenowl";
        runtimeInputs = [ pkgs.kitchenowlBackend.python ];
        text = ''
          export DB_DRIVER="sqlite"
          export NLTK_DATA="${pkgs.kitchenowlBackend.nltk_data}"
          export STORAGE_PATH="/var/lib/kitchenowl"
          python ${pkgs.kitchenowlBackend}/manage.py
        '';
      })
    ];
  };
}
