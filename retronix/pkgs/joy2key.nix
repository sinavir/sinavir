{ lib
, joy2keyd
, writeShellApplication
}:
writeShellApplication {
  name = "joy2key";

  runtimeInputs = [ joy2keyd ];

  text = ''
    mode="$1"
    [[ -z "$mode" ]] && mode="start"
    shift

    # allow overriding joystick device via __joy2key_dev env
    # (by default will use /dev/input/jsX which will scan all)
    device="/dev/input/jsX"
    [[ -n "$__joy2key_dev" ]] && device="$__joy2key_dev"

    params=("$@")
    if [[ "''${#params[@]}" -eq 0 ]]; then
        # Default button-to-keyboard mappings:
        # * cursor keys for axis/dpad
        # * enter, space, esc and tab for buttons 'a', 'b', 'x' and 'y'
        # * page up/page down for buttons 5,6 (shoulder buttons)
        params=(kcub1 kcuf1 kcuu1 kcud1 0x0a 0x20 0x1b 0x09 kpp knp)
    fi

    function kill_deamon() {
        pkill -f joy2keyd
        sleep 1
    }

    case "$mode" in
        start)
            if pgrep -f "joy2keyd" &>/dev/null; then
                kill_deamon
            fi
            joy2keyd "$device" "''${params[@]}" || exit 1
            ;;
        stop)
            kill_deamon
            ;;
    esac
    exit 0
    '';
}
