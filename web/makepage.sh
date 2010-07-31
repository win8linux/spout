#!/bin/sh

test $# -ne 2 && echo "usage: $0 title doap" && exit 1

title="$1"

cat <<- _EOF_
<!DOCTYPE html><html><head>
<style type="text/css">
body {  font-family: sans-serif; max-width: 75%; margin: auto;
	background: url(small.png) no-repeat 86% 2px; }
h1 { font-size: 1.6em; text-align: center; margin-bottom: 0.2em; }
h2 { font-size: 1.2em; border-bottom: thin solid black; margin-top: 0.1em; }
h3 { border: thin solid black; margin: auto; background: #cd2f2f;
	max-width: 15em; text-align: center; padding: 0.2em; margin-bottom: 0.3em; }
h3:hover { background: #ff9657; }
h3 a { color: black; text-decoration: none }
h3 a:hover { text-decoration: underline }
img { display: block; margin: auto; }
</style>
<link rel="alternate" type="text/turtle" title="rdf" href="doap.ttl" />
<title>$title</title>
</head><body>
_EOF_

sh web/doapheader.sh "$2" | smu

echo "![screenshot of $title](screen.png)"|smu

sh web/doapbutton.sh "$2" | smu

tail -n 12 < README | smu # history

echo "- - -"|smu

sh web/doapfooter.sh "$2" |smu

echo "</body></html>"
