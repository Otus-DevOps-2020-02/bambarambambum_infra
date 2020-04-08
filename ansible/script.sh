#!/bin/bash
gcloud compute instances list --format="value(name)" > file.txt
readarray -t names < file.txt
rm file.txt
gcloud compute instances list --format="value(networkInterfaces[0].accessConfigs.natIP)" > file.txt
readarray -t addrs < file.txt
rm file.txt
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
