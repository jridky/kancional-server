#!/bin/bash

. /etc/os-release

case "$VERSION_CODENAME" in
    jessie|stretch|buster|bullseye)
        export DISPLAY=:0
        OUTPUTS=$(xrandr 2>/dev/null | grep -E '^HDMI.*\sconnected\s' | awk '{print $1}')
        if [ $(echo "$OUTPUTS" | wc -l) -lt 2 ] ; then
            echo "Dual-screen requires two connected HDMI outputs."
            exit 1
        fi

        HDMI1=$(echo "$OUTPUTS" | sed -n '1p')
        HDMI2=$(echo "$OUTPUTS" | sed -n '2p')

        RES1=$(xrandr 2>/dev/null | grep -A1 "^$HDMI1 " | tail -1 | awk '{print $1}')
        RES2=$(xrandr 2>/dev/null | grep -A1 "^$HDMI2 " | tail -1 | awk '{print $1}')

        W1=$(echo "$RES1" | cut -dx -f1)
        H1=$(echo "$RES1" | cut -dx -f2)
        W2=$(echo "$RES2" | cut -dx -f1)
        H2=$(echo "$RES2" | cut -dx -f2)

        if [ "$W1" -ge "$W2" ] && [ "$H1" -ge "$H2" ] ; then
            BIGGER=$HDMI1; BIG_RES=$RES1
            SMALLER=$HDMI2; SMALL_RES=$RES2
        else
            BIGGER=$HDMI2; BIG_RES=$RES2
            SMALLER=$HDMI1; SMALL_RES=$RES1
        fi

        xrandr --fb "$BIG_RES" \
            --output "$BIGGER" --mode "$BIG_RES" --scale 1x1 \
            --output "$SMALLER" --mode "$SMALL_RES" --scale-from "$BIG_RES" --same-as "$BIGGER"
        ;;
    *)
        WAYLAND_SOCKET=$(find /run/user/1000 -maxdepth 1 -name 'wayland-[0-9]' 2>/dev/null | head -1)
        if [ -n "$WAYLAND_SOCKET" ] ; then
            WL_DISPLAY=$(basename "$WAYLAND_SOCKET")
            export WAYLAND_DISPLAY=$WL_DISPLAY
            export XDG_RUNTIME_DIR=/run/user/1000

            OUTPUTS=$(wlr-randr 2>/dev/null | grep '^HDMI' | awk '{print $1}')
            if [ $(echo "$OUTPUTS" | wc -l) -lt 2 ] ; then
                echo "Dual-screen requires two connected HDMI outputs."
                exit 1
            fi

            HDMI1=$(echo "$OUTPUTS" | sed -n '1p')
            HDMI2=$(echo "$OUTPUTS" | sed -n '2p')

            RES1=$(wlr-randr 2>/dev/null | grep -A2 "^$HDMI1" | grep 'current' | awk '{print $1}')
            RES2=$(wlr-randr 2>/dev/null | grep -A2 "^$HDMI2" | grep 'current' | awk '{print $1}')

            W1=$(echo "$RES1" | cut -dx -f1)
            H1=$(echo "$RES1" | cut -dx -f2)
            W2=$(echo "$RES2" | cut -dx -f1)
            H2=$(echo "$RES2" | cut -dx -f2)

            if [ "$W1" -le "$W2" ] ; then
                SMALLER_W=$W1
            else
                SMALLER_W=$W2
            fi

            SCALE1=$(awk "BEGIN {printf \"%.2f\", $W1 / $SMALLER_W}")
            SCALE2=$(awk "BEGIN {printf \"%.2f\", $W2 / $SMALLER_W}")

            wlr-randr --output "$HDMI1" --scale "$SCALE1" --pos 0,0 \
                      --output "$HDMI2" --scale "$SCALE2" --pos 0,0
        else
            export DISPLAY=:0
            echo "Wayland not detected, falling back to X11 mirroring."
            $0
        fi
        ;;
esac
