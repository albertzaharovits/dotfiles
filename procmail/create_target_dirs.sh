#!/bin/bash

# PIPE procmailrc content to create dirs

while IFS='' read -r line || [[ -n "$line" ]]; do
    if echo "$line" | grep -q -E "^.*MAILDIR=" - ; then
        MAILDIR=`echo "$line" | grep -Eo "^.*MAILDIR=(.*)" - | cut -d"=" -f 2`
        MAILDIR=`eval echo $MAILDIR`
    elif echo "$line" | grep -q -E "^[^:*][^=]+/$" - ; then
        mkdir -p "${MAILDIR%/}/$line/cur"
        mkdir -p "${MAILDIR%/}/$line/new"
        mkdir -p "${MAILDIR%/}/$line/tmp"
    fi
done
