{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.vscodium = {
    enable = true;
    profiles."lorev" = {
    extensions
    };
  };
}
