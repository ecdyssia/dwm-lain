#!/bin/bash

# Script de statusbar para dwm (sin batería, con CPU y RAM)
# Requiere: bash, xsetroot, pamixer (opcional)

while true; do
    # ---------------------
    # Fecha y hora
    datetime=$(date '+%Y-%m-%d %H:%M')

    # ---------------------
    # Memoria (RAM)
    mem_used=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
    memory="$mem_used"

    # ---------------------
    # CPU usage (porcentaje)
    # Calculamos diferencia entre dos lecturas de /proc/stat
    cpu_usage() {
        read -r cpu a b c d rest < /proc/stat
        total=$((a + b + c + d))
        idle=$d
        echo "$total $idle"
    }

    read -r total1 idle1 <<<"$(cpu_usage)"
    sleep 0.5
    read -r total2 idle2 <<<"$(cpu_usage)"

    total_diff=$((total2 - total1))
    idle_diff=$((idle2 - idle1))
    usage=$((100 * (total_diff - idle_diff) / total_diff))
    cpu="${usage}%"

    # ---------------------
    # Volumen (si pamixer está disponible)
    if command -v pamixer >/dev/null 2>&1; then
        vol_level=$(pamixer --get-volume)
        vol_mute=$(pamixer --get-mute)
        [ "$vol_mute" = "true" ] && vol_icon="" || vol_icon="󰕾"
        volume="${vol_icon}${vol_level}%"
    else
        volume="N/A"
    fi

    # ---------------------
    # Red (simple)
    if ip link show | grep -q "state UP"; then
        net="󰖩"
    else
        net="󰖪"
    fi

    # ---------------------
    # Construir texto final
    status="| $net | $volume | $cpu | $memory | $datetime |"

    # ---------------------
    # Actualizar barra
    xsetroot -name "$status"

    # Actualizar cada 5 segundos
    sleep 5
done

