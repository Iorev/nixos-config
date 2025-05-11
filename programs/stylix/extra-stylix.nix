{pkgs, ...}:
{
  stylix = {
    opacity = {
      applications = 0.1; #This doesn't seem to work
      desktop = 0.75;
      popups = 0.85;
      terminal = 0.95;
    };
    polarity = "dark";
    targets.floorp.profileNames = ["lorev"];
    targets.floorp.colorTheme.enable = true;

    cursor = {
      package = pkgs.whitesur-cursors;
      name = "WhiteSur-cursors";
      size = 1;
    };
    fonts = {
      serif = {
        package = pkgs.fira-sans;
        name = "FiraSans";
      };
      sansSerif = {
        package = pkgs.fira-sans;
        name = "FiraSans";
      };
      monospace = {
        package = pkgs.fira-mono;
        name = "Fira Code nerd font mono";
      };
    };
  };
}
