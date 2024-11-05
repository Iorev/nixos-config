{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      general = {
        gaps_in = 2;
        gaps_out = 10;
        border_size = 2;
        #"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        #"col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };
      exec-once = [
        "nm-applet --indicator"
        "waybar"
        "dunst"
      ];
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      decoration = {
        rounding = 10;
        "active_opacity" = 0.85;
        "inactive_opacity" = 0.65;
        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          vibrancy = 0.5;
        };
      };
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      misc = {disable_hyprland_logo = true;};

      input = {
        kb_layout = "it";
      };
      gestures = {
        workspace_swipe = true;
      };
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";
      "$browser" = "firefox";
      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, Q, killactive"
        "$mainMod, M, exit"
        "$mainMod, E, exec, $browser"
        "$mainMod, Space, togglefloating"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo"
        "$mainMod, V, togglesplit"

        # Move focus with mainMod + arrow keys
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # University shortcuts
        "Control_L&Alt_L, n, exec, nvim ~/current_course/"
        "Control_L&Alt_L, l, exec, python3 ~/university-setup/scripts/rofi-lectures.py"
        "Control_L&Alt_L, c, exec, python3 ~/university-setup/scripts/rofi-courses.py"
        "Control_L&Alt_L, v, exec, python3 ~/university-setup/scripts/rofi-lectures-view.py"
        "Control_L&Alt_L, b, exec, python3 ~/university-setup/scripts/backup.py"
        "Control_L&Alt_L, s, exec, bash ~/university-setup/scripts/select_subfolder"
        "Control_L&Alt_L, p, exec, bash ~/university-setup/scripts/select_file"
        "Control_L&Alt_L, y, exec, bash ~/university-setup/scripts/select_file rec"
        "Control_L&Alt_L, i, exec, bash ~/university-setup/scripts/scrsht_util.sh"

        "Control_L&Alt_L, w, exec, $browser -new-tab $(yq .link ~/current_course/info.yaml | tr -d '\"')"
        "Control_L&Alt_L, o, exec, $browser -new-tab $(yq .onedrive ~/current_course/info.yaml | tr -d '\"')"
        "Control_L&Alt_L, x, exec, $browser -new-tab $(yq .extra ~/current_course/info.yaml | tr -d '\"')"
        "Control_L&Alt_L, g, exec, $browser -new-tab $(yq .goodnotes ~/current_course/info.yaml | tr -d '\"')"
      ];
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle "
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
