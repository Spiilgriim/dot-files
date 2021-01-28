#!/bin/bash

on=$(pgrep polybar)

if [[ $on == "" ]]
then
  if type "xrandr" ; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      MONITOR=$m polybar --reload main &
    done
  else
    polybar --reload main &
  fi
else
  killall -q polybar
fi

