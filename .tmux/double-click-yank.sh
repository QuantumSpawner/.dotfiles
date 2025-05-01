#!/usr/bin/env bash

# Double/triple click to copy to the system clipboard in tmux. Inspired by
# [tmux-yank](https://github.com/tmux-plugins/tmux-yank). However, [issue #156]
# (https://github.com/tmux-plugins/tmux-yank/issues/156) is still not
# implemented in tmux-yank. This script iplements it without modifying
# tmux-yank.

# copied form [tmux-yank]
# (https://github.com/tmux-plugins/tmux-yank/blob/master/scripts/helpers.sh)
yank_selection_default="clipboard"
yank_selection_option="@yank_selection"

get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value
    option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

yank_selection() {
    get_tmux_option "$yank_selection_option" "$yank_selection_default"
}

command_exists() {
    local command="$1"
    type "$command" >/dev/null 2>&1
}

clipboard_copy_command() {
    # installing reattach-to-user-namespace is recommended on OS X
    if [ -n "$(override_copy_command)" ]; then
        override_copy_command
    elif command_exists "pbcopy"; then
        if command_exists "reattach-to-user-namespace"; then
            echo "reattach-to-user-namespace pbcopy"
        else
            echo "pbcopy"
        fi
    elif command_exists "clip.exe"; then # WSL clipboard command
        echo "cat | clip.exe"
    elif command_exists "wl-copy"; then # wl-clipboard: Wayland clipboard utilities
        echo "wl-copy"
    elif command_exists "xsel"; then
        echo "xsel -i --"$(yank_selection)
    elif command_exists "xclip"; then
        echo "xclip -selection $(yank_selection)"
    elif command_exists "putclip"; then # cygwin clipboard command
        echo "putclip"
    elif [ -n "$(custom_copy_command)" ]; then
        custom_copy_command
    fi
}

main() {
    local copy_command
    copy_command="$(clipboard_copy_command)"

    # modified from [stack overflow]
    # (https://stackoverflow.com/questions/31404140/can-i-use-double-click-to-select-and-copy-in-tmux)
    # Note: As of tmux 3.4, executing the following commands in command line
    # using `tmux bind-key ...` will result in `not in a mode` error.
    tmpfile=$(mktemp)

    cat <<EOF > "$tmpfile"
    # double clip to select and copy a word
    bind-key -T copy-mode-vi DoubleClick1Pane \
        select-pane \\; \\
        send-keys -X select-word \\; \\
        send-keys -X copy-pipe-no-clear "$copy_command" \\; \\
        run "sleep 0.3" \\; \\
        send-keys -X clear-selection
    
    bind-key -T copy-mode DoubleClick1Pane \
        select-pane \\; \\
        send-keys -X select-word \\; \\
        send-keys -X copy-pipe-no-clear "$copy_command" \\; \\
        run "sleep 0.3" \\; \\
        send-keys -X clear-selection

    bind-key -n DoubleClick1Pane \\
        select-pane \\; \\
        copy-mode -M \\; \\
        send-keys -X select-word \\; \\
        send-keys -X copy-pipe-no-clear "$copy_command" \\; \\
        run "sleep 0.3" \\; \\
        send-keys -X cancel
    
    # triple clip to select and copy a line
    bind-key -T copy-mode-vi TripleClick1Pane \
        select-pane \\; \\
        send-keys -X select-line \\; \\
        send-keys -X copy-pipe-no-clear "$copy_command" \\; \\
        run "sleep 0.3" \\; \\
        send-keys -X clear-selection

    bind-key -T copy-mode TripleClick1Pane \
        select-pane \\; \\
        send-keys -X select-line \\; \\
        send-keys -X copy-pipe-no-clear "$copy_command" \\; \\
        run "sleep 0.3" \\; \\
        send-keys -X clear-selection

    bind-key -n TripleClick1Pane \\
        select-pane \\; \\
        copy-mode -M \\; \\
        send-keys -X select-line \\; \\
        send-keys -X copy-pipe-no-clear "$copy_command" \\; \\
        run "sleep 0.3" \\; \\
        send-keys -X cancel
EOF

    tmux source-file $tmpfile
    rm $tmpfile
}
main
