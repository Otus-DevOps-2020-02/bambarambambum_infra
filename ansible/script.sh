#!/bin/bash
readarray -t names < ./data/names.txt
readarray -t addrs < ./data/addrs.txt
cat <<EOF
{
	"${names[0]}": {
        	"hosts": ["${addrs[0]}"]
	},
	"${names[-1]}": {
        	"hosts": ["${addrs[-1]}"]
	}
}
EOF
