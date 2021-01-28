#!/bin/bash

VAR1="%{F#8fbcbb} 阮 "
VAR2="$(spotifyctl status --format '%artist%: %title%' --max-length 50 --trunc '...')"
VAR3="%{F-}"

VAR4="$VAR1$VAR2$VAR3"
echo "$VAR4"
