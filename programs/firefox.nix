{
  pkgs,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.lorev = {
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };
      };
      search.force = true;

      bookmarks = [
        {
          name = "YT music";
          tags = ["music"];
          keyword = "music";
          url = "https://music.youtube.com";
        }
        {
          name = "Monthly Planner";
          tags = ["uni"];
          keyword = "uni goodnotes";
          url = "https://web.goodnotes.com/s/MUKxcGLiUj0TJ4Miu0cgAU#page-1";
        }
        {
          name = "GitLab AER";
          tags = ["uni"];
          keyword = "uni gitlab";
          url = "https://gitlab.com/polinetwork/AES";
        }
      ];

      settings = {
        "dom.security.https_only_mode" = true;
        "browser.download.panel.shown" = true;
        "identity.fxaccounts" = {
          enabled = true;
          "account.device.name" = "lorev nixOS";
        };
        "signon.rememberSignons" = false;
        "browser.translation.enabled " = false;
        "findbar.highlightAll" = true;
        browser = {
          warnOnClose = true;
          closeWindowWithLastTab = false;
          link.open_newwindow = {
            restriction = 0; # 0 = apply the setting under "browser.link.open_newwindow" to ALL new windows (even script windows with features
            override.external = 3; # 3 = open external links (from outside Firefox) in a new tab
          };
          newtabpage.enabled = false;
          vpn_promo.enabled = false;
        };
       extensions = {
         getAddons.showPane = false;
         pocket.enabled = false;
         webextensions.restrictedDomains = " ";
       };
        privacy.resistFingerprinting.block_modAddonManager = true;
      };

      userChrome = ''
        /* some css */
      '';

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        sponsorblock
        darkreader
        vimium
        facebook-container
        youtube-shorts-block
        dearrow
        foxyproxy-standard
      ];
    };
  };
}
