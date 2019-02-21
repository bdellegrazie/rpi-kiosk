#!/bin/sh
export DISPLAY=:0
/opt/vc/bin/tvservice -p
/bin/fbset -depth 8; /bin/fbset -depth 16; /usr/bin/xrefresh

