{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    "homepage/ha/key" = {};
    "homepage/ha/url" = {};
    "homepage/tailscale/key" = {};
    "homepage/tailscale/deviceid" = {};
    "homepage/gitea/key" = {};
    "homepage/gitea/url" = {};
    "homepage/miniflux/key" = {};
    "homepage/miniflux/url" = {};
    "homepage/uptimekuma/url" = {};
    "homepage/uptimekuma/slug" = {};
  };
  sops.templates."homepage-dashboard.env".content = ''
    HOMEPAGE_VAR_TAILSCALE_KEY=${config.sops.placeholder."homepage/tailscale/key"}
    HOMEPAGE_VAR_TAILSCALE_DEVICE_ID=${config.sops.placeholder."homepage/tailscale/deviceid"}
    HOMEPAGE_VAR_GITEA_KEY=${config.sops.placeholder."homepage/gitea/key"}
    HOMEPAGE_VAR_GITEA_URL=${config.sops.placeholder."homepage/gitea/url"}
    HOMEPAGE_VAR_MINIFLUX_KEY=${config.sops.placeholder."homepage/miniflux/key"}
    HOMEPAGE_VAR_MINIFLUX_URL=${config.sops.placeholder."homepage/miniflux/url"}
    HOMEPAGE_VAR_HA_KEY=${config.sops.placeholder."homepage/ha/key"}
    HOMEPAGE_VAR_HA_URL=${config.sops.placeholder."homepage/ha/url"}
    HOMEPAGE_VAR_UPTIMEKUMA_URL=${config.sops.placeholder."homepage/uptimekuma/url"}
    HOMEPAGE_VAR_UPTIMEKUMA_SLUG=${config.sops.placeholder."homepage/uptimekuma/slug"}
  '';

  services.homepage-dashboard = {
    enable = true;
    environmentFile = config.sops.templates."homepage-dashboard.env".path;

    settings = {
      title = "Hompeage";
      theme = "dark";
      layout = {
        "homelab" = {
          style = "row";
          columns = 2;
        };
        "bookmarks" = {
          style = "row";
          columns = 2;
        };
      };
    };

    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = ["/" "/home/lorev/archive/"];
          units = "metric"; # o "imperial"
        };
        resources = {
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
      {
        openmeteo = {
          latitude = 45.0703; # Cambia con la tua posizione
          longitude = 7.6869;
          timezone = "Europe/Rome";
          units = "metric";
        };
      }
      {
        datetime = {
          format = "dd/MM/yyyy HH:mm";
          locale = "it-IT";
        };
      }
    ];
    services = [
      {
        bookmarks = [
          {
            "BorgBackups" = {
              icon = "borgmatic";
              href = "http://borgbase.com";
              description = "Borg Backups";
            };
          }
          {
            "Tailscale" = {
              icon = "tailscale";
              href = "https://login.tailscale.com/admin/machines";
              description = "tailscale network";
              widget = {
                type = "tailscale";
                deviceid = "{{HOMEPAGE_VAR_TAILSCALE_DEVICE_ID}}";
                key = "{{HOMEPAGE_VAR_TAILSCALE_KEY}}";
              };
            };
          }
        ];
      }
      {
        homelab = [
          {
            "Home Assistant" = {
              icon = "home-assistant";
              href = "{{HOMEPAGE_VAR_HA_URL}}";
              description = "Controllo domotico";
              widget = {
                type = "homeassistant";
                url = "{{HOMEPAGE_VAR_HA_URL}}";
                key = "{{HOMEPAGE_VAR_HA_KEY}}";
                custom = {
                  "state" = "counter.numero_lavatrici_questo_mese";
                };
              };
            };
          }

          {
            "Miniflux" = {
              icon = "miniflux";
              href = "{{HOMEPAGE_VAR_MINIFLUX_URL}}";
              description = "RSS feed";
              widget = {
                type = "miniflux";
                url = "{{HOMEPAGE_VAR_MINIFLUX_URL}}";
                key = "{{HOMEPAGE_VAR_MINIFLUX_KEY}}";
              };
            };
          }

          {
            "UptimeKuma" = {
              icon = "uptime-kuma";
              href = "{{HOMEPAGE_VAR_UPTIMEKUMA_URL}}";
              description = "Homelab Status";
              widget = {
                type = "uptimekuma";
                url = "{{HOMEPAGE_VAR_UPTIMEKUMA_URL}}";
                slug = "{{HOMEPAGE_VAR_UPTIMEKUMA_SLUG}}";
              };
            };
          }

          {
            "Gitea" = {
              icon = "gitea";
              href = "{{HOMEPAGE_VAR_GITEA_URL}}";
              widget = {
                type = "gitea";
                url = "{{HOMEPAGE_VAR_GITEA_URL}}";
                key = "{{HOMEPAGE_VAR_GITEA_KEY}}";
              };
            };
          }
        ];
      }
    ];
  };
}
