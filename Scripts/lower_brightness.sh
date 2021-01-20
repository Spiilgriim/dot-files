#!/bin/bash

brightness=$(cat /sys/class/backlight/intel_backlight/actual_brightness) 

maxBrightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)

if [[ $brightness == "0" ]]
then
  newBrightness=$brightness
else
  newBrightness=$(($brightness - 5000))
  echo $newBrightness > /sys/class/backlight/intel_backlight/brightness
fi

