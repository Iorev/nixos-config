{pkgs, ...}: let
  inputImage = ../config/wallpaper/nix-transp.png;
  themeName = "nord";
  theme = "${pkgs.base16-schemes}/share/themes/${themeName}.yaml";
  wallpaper = pkgs.runCommand "nix-colored.png" {} ''
    COLOR=$(${pkgs.yq}/bin/yq -r .palette.base00 ${theme})
    ${pkgs.imagemagick}/bin/convert -background $COLOR -flatten ${inputImage} $out
  '';
in {
  stylix = {
    enable = true;
    image = wallpaper;
    base16Scheme = theme;
    opacity = {
      applications = 0.1; #This doesn't seem to work
      desktop = 0.75;
      popups = 0.85;
      terminal = 0.95;
    };
    # Librewolf themes
    targets.librewolf.profileNames = [ "lorev" ]; 
    targets.librewolf.colorTheme.enable = true;

    cursor = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors (Gruvbox)";
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
