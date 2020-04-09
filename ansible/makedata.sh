gcloud compute instances list --format="value(name)" > ./data/names.txt
readarray -t names < ./data/names.txt
gcloud compute instances list --format="value(networkInterfaces[0].accessConfigs.natIP)" > ./data/addrs.txt
readarray -t addrs < ./data/addrs.txt
