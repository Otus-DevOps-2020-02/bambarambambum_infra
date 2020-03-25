#!/bin/bash
gcloud compute instances create instance-full-3 \
  --boot-disk-size=10GB \
  --image-family reddit-full \
  --machine-type=g1-small \
  --tags default-puma-server \
  --restart-on-failure
