#!/bin/bash

set -x

LOCKF="$HOME/Maildir/lockfile"

function cleanup {
if [ "$?" != 13 ]; then
    rm -f "$LOCKF"
fi
}
trap cleanup EXIT

test -e "$LOCKF" && exit 13

echo `basename "$0"` > "$LOCKF"

inotifywait -e create --format "%w" -m ~/Maildir/*/*/new | while read NEWMAIL
do
echo "$NEWMAIL" | cut -d "/" -f 5- | xargs notify-send "CheckMail"
done
