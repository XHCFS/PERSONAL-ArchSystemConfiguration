#!/usr/bin/python3
"""Slide Waybar out of view while any floating window is visible.

Hyprland only animates a layer surface when it is mapped or unmapped, so
"hiding" the bar means actually stopping Waybar and "showing" it means
starting it again. Paired with

    hl.layer_rule({ match = { namespace = "waybar" }, animation = "slide" })

in hyprland.lua, that reads as a slide up / slide down.

Usage:
    waybar-float-autohide.py           run the daemon
    waybar-float-autohide.py toggle    hide/show the bar by hand and pin it there
    waybar-float-autohide.py auto      drop the manual pin, follow floating again
"""

import json
import os
import select
import signal
import socket
import subprocess
import sys

# "restart" gives the animated slide; "signal" hides instantly via SIGUSR1 and
# leaves Waybar running.
MODE = "restart"

# Collapse a burst of events into one restart. Dragging a window between
# workspaces or toggling float twice in a row fires several events; without
# this the bar would flicker through a restart for each one.
DEBOUNCE = 0.15

RUNTIME = os.environ.get("XDG_RUNTIME_DIR", "/tmp")

# While this file exists it holds "show" or "hide" and the daemon keeps its
# hands off -- a manual toggle wins until it is cleared with `auto`.
OVERRIDE = f"{RUNTIME}/waybar-float-autohide.override"

EVENTS = {
    "changefloatingmode",
    "openwindow",
    "closewindow",
    "workspace",
    "workspacev2",
    "movewindow",
    "movewindowv2",
    "focusedmon",
    "monitoradded",
    "monitorremoved",
    "fullscreen",
}


def hyprctl(*args):
    out = subprocess.run(
        ["hyprctl", "-j", *args], capture_output=True, text=True, check=True
    ).stdout
    return json.loads(out)


def floating_visible():
    """Is a floating window on screen anywhere right now?"""
    visible = {m["activeWorkspace"]["id"] for m in hyprctl("monitors")}
    return any(
        c["floating"] and not c.get("hidden") and c["workspace"]["id"] in visible
        for c in hyprctl("clients")
    )


def waybar_pids():
    out = subprocess.run(["pidof", "waybar"], capture_output=True, text=True).stdout
    return [int(p) for p in out.split()]


def waybar_shown():
    if MODE == "restart":
        return bool(waybar_pids())
    # In signal mode Waybar keeps running but drops its exclusive zone, so ask
    # Hyprland what the bar is actually reserving.
    return any(any(m["reserved"]) for m in hyprctl("monitors"))


def set_shown(shown):
    if MODE != "restart":
        for pid in waybar_pids():
            os.kill(pid, signal.SIGUSR1)
    elif shown:
        subprocess.Popen(
            ["waybar"],
            start_new_session=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    else:
        subprocess.run(["pkill", "-x", "waybar"])


def override():
    try:
        with open(OVERRIDE) as f:
            return f.read().strip()
    except OSError:
        return None


def sync():
    if override():  # pinned by hand, leave it alone
        return
    want = not floating_visible()
    if want != waybar_shown():
        set_shown(want)


def toggle():
    want = not waybar_shown()
    with open(OVERRIDE, "w") as f:
        f.write("show" if want else "hide")
    set_shown(want)


def auto():
    try:
        os.remove(OVERRIDE)
    except FileNotFoundError:
        pass
    sync()


def single_instance():
    """Abstract-socket lock, so a second copy exits instead of fighting the first."""
    lock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    try:
        lock.bind("\0waybar-float-autohide")
    except OSError:
        sys.exit("already running")
    return lock  # kept alive for the process lifetime


def run():
    _lock = single_instance()
    sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if not sig:
        sys.exit("HYPRLAND_INSTANCE_SIGNATURE not set")

    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(f"{RUNTIME}/hypr/{sig}/.socket2.sock")

    buf = b""
    pending = False
    while True:
        # Once something interesting lands, wait for the socket to go quiet for
        # DEBOUNCE seconds before touching the bar.
        if not select.select([sock], [], [], DEBOUNCE if pending else None)[0]:
            pending = False
            try:
                sync()
            except Exception as e:  # never die on a transient hyprctl failure
                print(f"waybar-float-autohide: {e}", file=sys.stderr)
            continue

        chunk = sock.recv(4096)
        if not chunk:
            return
        buf += chunk
        *lines, buf = buf.split(b"\n")
        for line in lines:
            if line.decode("utf-8", "replace").split(">>", 1)[0] in EVENTS:
                pending = True


if __name__ == "__main__":
    action = sys.argv[1] if len(sys.argv) > 1 else None
    {None: run, "toggle": toggle, "auto": auto}[action]()
