#!/bin/bash
#
# chef-backup.sh - backup chef components in sane format
#

PREFIX=backups

COMPONENTS=""
#COMPONENTS="$COMPONENTS cookbook"
#COMPONENTS="$COMPONENTS databag"
COMPONENTS="$COMPONENTS environment"
#COMPONENTS="$COMPONENTS node"
#COMPONENTS="$COMPONENTS role"

for component in $COMPONENTS; do

    echo doing $component
    rm -rf ${PREFIX}/${component}s
    install -d ${PREFIX}/${component}s
    case $component in
	cookbook)
    	    knife $component list | while read element item; do
		echo "$component: $element $item"
		# Loading cookbooks in shared directories gets very, very odd
		install -d ${PREFIX}/${component}s/${element}-${item}
		knife cookbook download $element $item -d ${PREFIX}/${component}s/${element}-${item}
	    done
	    ;;
	databag)
	    # name of directory and element in knife command, differ
    	    knife data bag list | while read element item; do
		install -d ${PREFIX}/${component}s/$element
		echo "$component: $element $item"
		knife data bag show $element $item --format  json > ${PREFIX}/${component}s/$element/$item.json
	    done
	    ;;
	*)
            install -m 700 -d ${PREFIX}/${component}s
    	    knife $component list | while read element version; do
		echo "element: $element"
		if [ -n "$version" ]; then
    		    echo Error: knife list $component reported $element $version, skipping >&2
    		    continue
    		else
		    knife $component show $element --format json | jsonlint -f > ${PREFIX}/${component}s/$element.json
    		fi
    	    done
	    ;;
    esac
done

