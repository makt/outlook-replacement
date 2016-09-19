#!/bin/sh
iconv -f $1 -t utf8 |
perl -pe '
 s,<o:p>.*?</o:p>,,g' |
sed -r '
 s,</p><p class=.?MsoPlainText.?>,<br>,g
 s,<div style=.border:none;border-top:solid #B5C4DF[^>]*><p class=.?MsoNormal.?><b><span [^>]*>,<div><p><b><span>_____________________________________________<br>,g
 s/(\xc2\xa0|&nbsp;) _{79}([^_])/  ________________________________________________\2/g'
