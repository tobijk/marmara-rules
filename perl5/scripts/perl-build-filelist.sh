#!/bin/sh

find | \
grep -v -e '/local' -e '/man' -e 'pod$' -e 'CORE' -e '/usr/bin' -e '/usr/lib/libperl' | \
sort | \
sed 's/^\.//g' | \
while read LINE; do
    test -d "./$LINE" && echo "<dir src=\"$LINE\"/>" || echo "<file src=\"$LINE\"/>"
done
