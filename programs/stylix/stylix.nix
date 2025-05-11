{pkgs, ...}: let
  inputImage = ../../config/wallpaper/nix-transp.png;
  # https://tinted-theming.github.io/tinted-gallery/
  themeName = "everforest-dark-hard"; 
  theme = "${pkgs.base16-schemes}/share/themes/${themeName}.yaml";
  wallpaper = pkgs.runCommand "nix-colored.png" {} ''
    COLOR=$(${pkgs.yq}/bin/yq -r .palette.base00 ${theme})
    ${pkgs.imagemagick}/bin/convert -background $COLOR -flatten ${inputImage} $out
  '';
in {
  stylix = {
    enable = true;
    base16Scheme = theme;
    image = wallpaper;
  };
}
