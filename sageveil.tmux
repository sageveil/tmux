#!/usr/bin/env bash
#
# sageveil - tmux theme
#
# Inspired by rose-pine/tmux

read_tmux_setting() {
    local option value default
    option="$1"
    default="$2"
    value="$(tmux show-option -gqv "$option")"

    if [ -n "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}

queue_global_option() {
    local option=$1
    local value=$2
    command_queue+=(set-option -gq "$option" "$value" ";")
}

queue_window_option() {
    local option=$1
    local value=$2
    command_queue+=(set-window-option -gq "$option" "$value" ";")
}

queue_unset_option() {
    local option=$1
    command_queue+=(set-option -gu "$option" ";")
}

join_segments() {
    local glue=$1
    shift
    local chunk result=""
    for chunk in "$@"; do
        [[ -z "$chunk" ]] && continue
        if [[ -n "$result" && -n "$glue" ]]; then
            result+="$glue"
        fi
        result+="$chunk"
    done
    printf '%s' "$result"
}

main() {
    sageveil_bg="#101411"
    sageveil_fg="#A8AFA6"
    sageveil_muted_fg="#8C918C"
    sageveil_red="#935155"
    sageveil_dyellow="#B4A05A"
    sageveil_byellow="#d4b573"
    sageveil_green="#67825B"
    sageveil_cyan="#916f54"
    sageveil_magenta="#9D868C"
    sageveil_border="#4E504C"
    sageveil_blue="#65806B"
    sageveil_bblue="#74997e"
    sageveil_bcyan="#a37856"
    sageveil_bmagenta="#baa5ab"
    sageveil_bgreen="#809a73"
    sageveil_bred="#b07a77"
    sageveil_surface="#1D2320"
    sageveil_overlay="#1F2624"
    sageveil_highlight="#3F322C"
    sageveil_dim="#616560"

    local command_queue=()

    queue_global_option "status" "on"
    queue_global_option status-style "fg=$sageveil_bgreen,bg=$sageveil_bg"
    queue_global_option status-left-length "200"
    queue_global_option status-right-length "200"

    queue_global_option message-style "fg=$sageveil_fg,bg=$sageveil_overlay"
    queue_global_option message-command-style "fg=$sageveil_surface,bg=$sageveil_bred"

    queue_global_option pane-border-style "fg=$sageveil_border"
    queue_global_option pane-active-border-style "fg=$sageveil_highlight"
    queue_global_option display-panes-active-colour "${sageveil_bblue}"
    queue_global_option display-panes-colour "${sageveil_bmagenta}"

    queue_window_option window-status-style "fg=${sageveil_blue},bg=${sageveil_bg}"
    queue_window_option window-status-activity-style "fg=${sageveil_surface},bg=${sageveil_bcyan}"
    queue_window_option window-status-current-style "fg=${sageveil_byellow},bg=${sageveil_bg}"

    # Shows tmux session name
    local show_session
    show_session="$(read_tmux_setting "@sv_show_session" "on")"
    readonly show_session

    # Shows username of the user the tmux session is run by
    local show_user
    show_user="$(read_tmux_setting "@sv_show_user" "")"
    readonly show_user

    # Shows hostname of the computer the tmux session is run on
    local show_host
    show_host="$(read_tmux_setting "@sv_host" "")"
    readonly show_host

    # Date and time
    local show_date_time
    show_date_time="$(read_tmux_setting "@sv_show_date_time" "")"
    readonly show_date_time

    # Date and time format
    local date_time_format
    date_time_format="$(read_tmux_setting "@sv_date_time_format" "%H:%M %d %b")"
    readonly date_time_format

    # Shows truncated current working directory
    local show_directory
    show_directory="$(read_tmux_setting "@sv_show_directory" "")"

    # Show icon then prefix is active
    local show_prefix_indicator
    show_prefix_indicator="$(read_tmux_setting "@sv_show_prefix_indicator" "on")"
    readonly show_prefix_indicator

    # Show icon when pane is zoomed in (prefix + z)
    local show_zoom_indicator
    show_zoom_indicator="$(read_tmux_setting "@sv_show_zoom_indicator" "on")"
    readonly show_zoom_indicator

    # Show number of active sessions
    local show_session_count
    show_session_count="$(read_tmux_setting "@sv_show_session_count" "")"
    readonly show_session_count

    # Displays current directory as window name
    local use_window_directory_as_window_name
    use_window_directory_as_window_name="$(read_tmux_setting "@sv_directory_as_window_name" "")"
    readonly use_window_directory_as_window_name

    # Only windows mode, disables other segments
    local only_windows
    only_windows="$(read_tmux_setting "@sv_only_windows" "")"
    readonly only_windows

    # Allows user to set a few custom sections (for integration with other plugins)
    # Before the plugin's left section
    local status_left_prepend_section
    status_left_prepend_section="$(read_tmux_setting "@sv_status_left_prepend_section" "")"
    readonly status_left_prepend_section
    #
    # after the plugin's left section
    local status_left_append_section
    status_left_append_section="$(read_tmux_setting "@sv_status_left_append_section" "")"
    readonly status_left_append_section
    # Before the plugin's right section
    local status_right_prepend_section
    status_right_prepend_section="$(read_tmux_setting "@sv_status_right_prepend_section" "")"
    readonly status_right_prepend_section
    #
    # after the plugin's right section
    local status_right_append_section
    status_right_append_section="$(read_tmux_setting "@sv_status_right_append_section" "")"
    readonly status_right_append_section

    # Icons
    local current_session_icon
    current_session_icon="$(read_tmux_setting "@sv_session_icon" "󰕰")"
    readonly current_session_icon

    local username_icon
    username_icon="$(read_tmux_setting "@sv_username_icon" "")"
    readonly username_icon

    local hostname_icon
    hostname_icon="$(read_tmux_setting "@sv_hostname_icon" "󰒋")"
    readonly hostname_icon

    local date_time_icon
    date_time_icon="$(read_tmux_setting "@sv_date_time_icon" "󰃰")"
    readonly date_time_icon

    local current_folder_icon
    current_folder_icon="$(read_tmux_setting "@sv_folder_icon" "")"
    readonly current_folder_icon

    local prefix_icon
    prefix_icon="$(read_tmux_setting "@sv_prefix_icon" "󰘳")"
    readonly prefix_icon

    local zoom_icon
    zoom_icon="$(read_tmux_setting "@sv_zoom_icon" "󰁌")"
    readonly zoom_icon

    local session_count_icon
    session_count_icon="$(read_tmux_setting "@sv_window_count_icon" "󰕢")"
    readonly session_count_icon

    # Custom separator between window index and name, replacing ':', e.g. " → "
    local window_idx_name_separator
    window_idx_name_separator="$(read_tmux_setting "@sv_window_idx_name_separator" "·")"
    readonly window_idx_name_separator

    # Custom separator that goes between each window's segment
    local window_segments_separator
    window_segments_separator="$(read_tmux_setting "@sv_window_segments_separator" "  ")"

    local default_separator=" "
    # Custom separator for right section, e.g. "  "
    local right_separator
    right_separator="$(read_tmux_setting "@sv_right_separator" "$default_separator")"

    # Custom separator for left section, e.g. "  "
    local left_separator
    left_separator="$(read_tmux_setting "@sv_left_separator" "$default_separator")"

    local session_segment
    readonly session_segment=" #[fg=$sageveil_magenta]$current_session_icon #[fg=$sageveil_magenta]#S "

    local session_count_segment
    readonly session_count_segment=" #[fg=$sageveil_cyan]$session_count_icon #[fg=$sageveil_cyan]#{server_sessions}$default_separator"

    local user_segment
    readonly user_segment="#[fg=$sageveil_cyan]#(whoami)#[fg=$sageveil_blue]$right_separator#[fg=$sageveil_blue]$username_icon"

    local host_segment
    readonly host_segment="$default_separator#[fg=$sageveil_cyan]#H#[fg=$sageveil_blue]$right_separator#[fg=$sageveil_blue]$hostname_icon"

    local date_time_segment
    readonly date_time_segment=" #[fg=$sageveil_cyan]$date_time_format#[fg=$sageveil_blue]$right_separator#[fg=$sageveil_blue]$date_time_icon "

    local directory_segment
    readonly directory_segment="$default_separator#[fg=$sageveil_dyellow]$current_folder_icon #[fg=$sageveil_dyellow]#{b:pane_current_path} "

    local prefix_indicator_segment
    readonly prefix_indicator_segment="#{?client_prefix,#[fg=$sageveil_bred]$prefix_icon$default_separator,}"

    local zoom_indicator_segment
    readonly zoom_indicator_segment="#{?window_zoomed_flag,#[fg=$sageveil_bgreen]$zoom_icon$default_separator,}"

    ### WINDOW STATUS
    local win_sep=":"
    if [[ -n "$window_idx_name_separator" ]]; then
        win_sep="$window_idx_name_separator"
    elif [[ "$left_separator" != "$default_separator" ]]; then
        win_sep="$left_separator"
    fi

    local win_name="W"
    if [[ "$use_window_directory_as_window_name" == "on" ]]; then
        win_name="{b:pane_current_path}"
    fi

    # Custom window status that goes between the number and the window name
    local window_segment_format="#[fg=$sageveil_blue]#I#[fg=$sageveil_blue]$win_sep#[fg=$sageveil_blue]#$win_name"
    local current_window_segment_format="#I#[fg=$sageveil_byellow]$win_sep#[fg=$sageveil_byellow]#$win_name"

    # Left status segments (order-sensitive)
    local -a left_segments=()

    # Right status segments (order-sensitive)
    local -a right_segments=()

    queue_window_option window-status-format "$window_segment_format"
    queue_window_option window-status-current-format "$current_window_segment_format"

    # The append and prepend sections are for inter-plugin compatibility
    # and extension
    if [[ "$status_left_prepend_section" != "" ]]; then
        left_segments+=("$status_left_prepend_section")
    fi

    if [[ "$show_session" = "on" ]]; then
        left_segments+=("$session_segment")
    fi

    if [[ "$show_session_count" == "on" ]]; then
        left_segments+=("$session_count_segment")
    fi

    if [[ "$status_left_append_section" != "" ]]; then
        left_segments+=("$status_left_append_section$default_separator")
    fi

    if [[ "$status_right_prepend_section" != "" ]]; then
        right_segments+=("$status_right_prepend_section")
    fi

    if [[ "$show_prefix_indicator" == "on" ]]; then
        right_segments+=("$prefix_indicator_segment")
    fi

    if [[ "$show_zoom_indicator" == "on" ]]; then
        right_segments+=("$zoom_indicator_segment")
    fi

    if [[ "$show_user" == "on" ]]; then
        right_segments+=("$user_segment")
    fi

    if [[ "$show_host" == "on" ]]; then
        right_segments+=("$host_segment")
    fi

    if [[ "$show_directory" == "on" ]]; then
        right_segments+=("$directory_segment")
    fi

    if [[ "$show_date_time" == "on" ]]; then
        right_segments+=("$date_time_segment")
    fi

    if [[ "$status_right_append_section" != "" ]]; then
        right_segments+=("$status_right_append_section")
    fi

    local base_left_line
    base_left_line="$(join_segments "" "${left_segments[@]}")"

    local base_right_line
    base_right_line="$(join_segments "" "${right_segments[@]}")"

    local final_left="$base_left_line"
    local final_right="$base_right_line"

    queue_window_option window-status-separator "$window_segments_separator"

    if [[ "$only_windows" == "on" ]]; then
        final_left=""
        final_right=""
    fi

    queue_global_option status-left "$final_left"
    queue_global_option status-right "$final_right"

    queue_window_option clock-mode-colour "${sageveil_red}"
    queue_window_option mode-style "fg=${sageveil_dyellow}"

    tmux "${command_queue[@]}"
}

main "$@"
