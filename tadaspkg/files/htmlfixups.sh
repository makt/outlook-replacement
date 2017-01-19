#!/bin/sh
iconv -c -f $1 -t utf8 |
perl -p -0777 -e '
 s,</p>\n*<p dir="ltr">,<br>,g;
 s,</p>\n*<p class[^>]*>,<br>,g;
 s,<o:p>.*?</o:p>,,g' |
sed -r '
 s,<div style=.border:none;border-top:solid #B5C4DF[^>]*><p class=.?MsoNormal.?><b><span [^>]*>,<div><p><b><span>_____________________________________________<br>,g
 s/(\xc2\xa0|&nbsp;) _{79}([^_])/  ________________________________________________\2/g'
