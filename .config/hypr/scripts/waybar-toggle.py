#!/usr/bin/python3
"""Toggle Waybar, sliding it out of view.

Hyprland only animates a layer surface when it is mapped or unmapped -- a
SIGUSR1 hide leaves the surface mapped and emits no layer events at all -- so
hiding means stopping Waybar and showing means starting it. Paired with

    hl.layer_rule({ match = { namespace = "waybar" }, animation = "slide" })

in hyprland.lua, that reads as a slide up / slide down.
"""

import subprocess


def running():
    return bool(subprocess.run(["pidof", "waybar"], capture_output=True).stdout.split())


if running():
    subprocess.run(["pkill", "-x", "waybar"])
else:
    subprocess.Popen(
        ["waybar"],
        start_new_session=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
