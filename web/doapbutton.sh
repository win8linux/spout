#!/bin/sh

test $# -ne 1 && echo "usage: $0 doap" && exit 1

rdf="$1"

q="PREFIX doap: <http://usefulinc.com/ns/doap#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT ?name ?ver ?file
WHERE {
?p a doap:Project;
   doap:name ?name;
   doap:release ?rel.
?rel doap:revision ?ver;
   doap:file-release ?file.
}"

roqet -q -r csv -e "$q" -D /dev/stdin < $rdf | sed '/^Result/d' \
| while read r; do
	name=`echo $r | awk -F , '{print $2}'| sed -e 's/"\(.*\)"/\1/'`
	version=`echo $r | awk -F , '{print $3}'| sed -e 's/"\(.*\)"/\1/'`
	fileurl=`echo $r | awk -F , '{print $4}'| sed -e 's/uri(\(.*\))/\1/'`

	cat <<- _EOF_
### [Download $name $version]($fileurl)  
### ([GPG signature]($fileurl.sig))
_EOF_
done
