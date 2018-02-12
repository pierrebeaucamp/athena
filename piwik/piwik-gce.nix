{
  network.description = "Piwik";

  resources = {
    gceNetworks.piwik-net = {
      addressRange = "10.0.0.0/24";
      firewall.allow-http.allowed.tcp = [ 80 443 ];
    };

    gceStaticIPs.public-ip.region = "northamerica-northeast1";
  };

  piwik = { resources, pkgs, ...}: {
    networking = {
      hostName = "pierrebeaucamp.com";
      firewall.allowedTCPPorts = [ 80 443 ];
    };

    deployment = {
      targetEnv = "gce";
      gce = {
        region = "northamerica-northeast1-b";
        instanceType = "f1-micro";
        network = resources.gceNetworks.piwik-net;
        ipAddress = resources.gceStaticIPs.public-ip;
      };
    };

    services = {
      nginx.enable = true;

      piwik = {
        enable = true;
        nginx.default = true;
      };

      mysql = {
        enable = true;
        package = pkgs.mariadb;
        initialScript = pkgs.writeText "piwikInit.sql" ''
          INSTALL PLUGIN unix_socket SONAME 'auth_socket';
          CREATE DATABASE piwik;
          CREATE USER 'piwik'@'localhost' IDENTIFIED WITH unix_socket;
          GRANT ALL PRIVILEGES ON piwik.* TO 'piwik'@'localhost';
        '';
      };
    };
  };
}
