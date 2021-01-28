#!/bin/bash

git add .
if [$1 == ""] 
then
  git commit -m "$(date +'%c')"
else
  git commit -m "$1"
fi

git push 

shift

for item in "$@" ; do
  git push $item
done

