#!/bin/sh

test $# -ne 1 && echo "usage: $0 doap" && exit 1

rdf="$1"

q="PREFIX doap: <http://usefulinc.com/ns/doap#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT ?home ?repo ?license ?maintainer ?maintainerhome ?lang
WHERE {
?p a doap:Project;
   doap:homepage ?home;
   doap:repository ?r;
   doap:license ?license;
   doap:programming-language ?lang;
   doap:maintainer ?m.
?r doap:location ?repo.
?m foaf:name ?maintainer;
   foaf:homepage ?maintainerhome.
}"

roqet -q -r csv -e "$q" -D /dev/stdin < $rdf | sed '/^Result/d' \
| while read r; do
	home=`echo $r | awk -F , '{print $2}'| sed -e 's/uri(\(.*\))/\1/'`
	repo=`echo $r | awk -F , '{print $3}'| sed -e 's/uri(\(.*\))/\1/'`
	licenseuri=`echo $r | awk -F , '{print $4}'| sed -e 's/uri(\(.*\))/\1/'`
	maint=`echo $r | awk -F , '{print $5}'| sed -e 's/"\(.*\)"/\1/'`
	mainthome=`echo $r | awk -F , '{print $6}'| sed -e 's/uri(\(.*\))/\1/'`
	lang=`echo $r | awk -F , '{print $7}'| sed -e 's/"\(.*\)"/\1/'`
	test "$licenseuri" = "http://www.gnu.org/licenses/gpl.html" && license="GPL"
	test "$licenseuri" = "http://creativecommons.org/licenses/MIT/" && license="MIT"

	cat <<- _EOF_
- Project homepage: [$home]($home)
- Code repository: [$repo]($repo)
- Maintainer: [$maint]($mainthome)
- Language: $lang
- License: [$license]($licenseuri)
_EOF_
done
