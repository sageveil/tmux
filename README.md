<p align="center">
    <img src="https://raw.githubusercontent.com/sageveil/sageveil/refs/heads/main/assets/sageveil-logo.png" width="80" />
    <h2 align="center">@sageveil/tmux</h2>
</p>

<p align="center">A minimalist low-contrast, green-tinted colorscheme 🌱</p>

# @sageveil/tmux

## Overview

sageveil’s tmux port renders a status line that matches the palette used across the rest of the ecosystem. It ships as a standalone tmux script, so you can source it from any existing `tmux.conf` without bringing in extra plugins.

## Build from the monorepo

All sageveil ports will be distributed in their dedicated repos (comming soon). Until then they must be built from source.

1. Install dependencies once: `pnpm install`
2. Render the theme: `pnpm nx run tmux:generate`
3. Grab the assets from `dist/ports/tmux/`

## Apply sageveil

### Prebuilt artifacts (coming soon)

Links to published releases will be added once the standalone tmux repository goes live.

### Build locally

1. Copy or symlink `sageveil.tmux` into your tmux config directory (for example `~/.config/tmux/sageveil.tmux`).
2. Source it from your main config:

   ```tmux
   # Set any overrides before sourcing the theme
   set -g @sv_show_user "on"
   set -g @sv_window_idx_name_separator " • "

   # Source the generated status line
   source-file "~/.config/tmux/sageveil.tmux"
   ```

3. Reload tmux with `tmux source-file ~/.tmux.conf` to apply the changes.

## Configuration reference

All options are standard tmux global options. Set them **before** you source `sageveil.tmux` so the template can pick up your changes.

### Segment toggles

| Option | Default | Description |
| --- | --- | --- |
| `@sv_show_session` | `on` | Shows the current session name (`#S`) on the left. |
| `@sv_show_prefix_indicator` | `on` | Adds the prefix icon whenever the tmux prefix is pressed. |
| `@sv_show_zoom_indicator` | `on` | Highlights zoomed panes (prefix + `z`). |
| `@sv_show_session_count` | `""` (off) | Displays the total number of server sessions. |
| `@sv_show_user` | `""` (off) | Set to `on` to show the current UNIX user on the right. |
| `@sv_show_host` | `""` (off) | Set to `on` to show the hostname on the right. |
| `@sv_show_date_time` | `""` (off) | Set to `on` to render the clock segment. |
| `@sv_show_directory` | `""` (off) | Set to `on` to display the active pane's working directory. |
| `@sv_directory_as_window_name` | `""` (off) | Set to `on` to use the active pane directory as the window title. |
| `@sv_only_windows` | `""` (off) | Set to `on` to hide the left/right status bars and show only the window list. |

### Formatting and layout

| Option | Default | Description |
| --- | --- | --- |
| `@sv_date_time_format` | `%H:%M %d %b` | Format string fed to the clock segment. |
| `@sv_window_idx_name_separator` | `·` | Separator between the window index (`#I`) and name (`#W`). |
| `@sv_window_segments_separator` | double space | Separator placed between each window segment. |
| `@sv_left_separator` | single space | Glue used to join items in the left status line. |
| `@sv_right_separator` | single space | Glue used to join items in the right status line. |

### Integration hooks

| Option | Default | Description |
| --- | --- | --- |
| `@sv_status_left_prepend_section` | `""` | Prepends raw tmux status text to the left side (runs before sageveil segments). |
| `@sv_status_left_append_section` | `""` | Appends raw tmux status text after the sageveil left segments. |
| `@sv_status_right_prepend_section` | `""` | Prepends raw tmux status text to the right side. |
| `@sv_status_right_append_section` | `""` | Appends raw tmux status text after the sageveil right segments. |

### Icon glyphs

These defaults assume a Nerd Font. Override any entry if your terminal font maps different glyphs.

| Option | Default glyph | Purpose |
| --- | --- | --- |
| `@sv_session_icon` | `󰕰` | Session segment icon. |
| `@sv_window_count_icon` | `󰕢` | Server session count indicator. |
| `@sv_username_icon` | `` | Username indicator on the right side. |
| `@sv_hostname_icon` | `󰒋` | Hostname indicator. |
| `@sv_date_time_icon` | `󰃰` | Clock segment icon. |
| `@sv_folder_icon` | `` | Active directory indicator. |
| `@sv_prefix_icon` | `󰘳` | Prefix active indicator. |
| `@sv_zoom_icon` | `󰁌` | Zoomed pane indicator. |

## Development

[sageveil/sageveil](https://github.com/sageveil/sageveil) is the main project monorepo. All development happens there.

[sageveil/tmux](https://github.com/sageveil/tmux) is used only for easy distribution of the ready-to-use tmux colorscheme plugin.
