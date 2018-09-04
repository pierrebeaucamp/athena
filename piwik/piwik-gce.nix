{
  network.description = "Piwik";

  resources = {
    gceNetworks.piwik-net = {
      addressRange = "10.0.0.0/24";
      firewall.allow-http.allowed.tcp = [ 80 443 ];
    };

    gceStaticIPs.public-ip.region = "us-east1";
  };

  piwik = { resources, pkgs, ...}: {
    networking = {
      hostName = "pierrebeaucamp.com";
      firewall.allowedTCPPorts = [ 80 443 ];
    };

    deployment = {
      targetEnv = "gce";
      gce = {
        region = "us-east1-b";
        instanceType = "f1-micro";
        rootDiskSize = 30;
        network = resources.gceNetworks.piwik-net;
        ipAddress = resources.gceStaticIPs.public-ip;
      };
    };

    services = {
      nginx.enable = true;

      matomo = {
        enable = true;
        nginx.default = true;
      };

      mysql = {
        enable = true;
        package = pkgs.mariadb;

        ensureDatabases = [ "piwik" ];
        ensureUsers = [
          {
            name = "matomo";
            ensurePermissions = {
              "piwik.*" = "ALL PRIVILEGES";
            };
          }
        ];

        extraOptions = ''
          max_allowed_packet = 128M
        '';
      };
    };
  };
}
