#!/bin/bash
[ $# -eq 0 ] && { echo "usage: $0 hostname"; exit 1; }
CURRENTNAME=`hostname`
[ "$CURRENTNAME" == "$1" ] && [ `cat /etc/hostname | grep -c "$1"` -eq 1 ] || ( echo "Hostname is: $CURRENTNAME and not correctly set up.")
