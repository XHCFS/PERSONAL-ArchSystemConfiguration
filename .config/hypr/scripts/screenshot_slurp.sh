#!/bin/sh

# Define the colors here, using hex RGBA format
BORDER_COLOR='#3B42528F'  # Fully transparent black
FILL_COLOR='#3B425280'    # Fully transparent black
DIM_COLOR='#3B42520F'     # Nord1 with 75% opacity

# Use the defined colors in the slurp command
grim -g "$(slurp -b "${BORDER_COLOR}" -c "${FILL_COLOR}" -d "${DIM_COLOR}")" "$1"
