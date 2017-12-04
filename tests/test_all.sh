#!/bin/bash
THISFILE=`basename "$0"`
for file in *; do
  [ ! "$file" == "$THISFILE" ] && ruby "$file";
done
