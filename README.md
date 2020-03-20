# bambarambambum_infra
bambarambambum Infra repository

#SSH to GCP host
1. The way to connect in one command to the "little-1" host
ssh -J mikh_androsov@35.242.221.114 mikh_androsov@little-1

2. Another way to connect to the host by alias
1) Set configuration ~/.ssh/config

Host bastion
  HostName 35.242.221.114
  User mikh_androsov
  ForwardAgent yes
Host little
  HostName 10.156.0.3
  User mikh_androsov
  ProxyJump bastion

2) Use the command "ssh little"

#Pritunl VPN configuration
Host: little-1 (IP: 10.156.0.3)
OS: Ubuntu 16.04

Installation script Pritunl: setupvpn.sh

Address: https://35.242.221.114/
Login: pritunl
Password: pritunl

Configuration -
Users and Organizations
  Organization: test
  Users: test
  PIN: 6214157507237678334670591556762
Servers
  Network: 192.168.233.0/24
  Port: 12503/udp

Configuration file for OpenVPN: cloud-bastion.ovpn

bastion_IP = 35.242.221.114
someinternalhost_IP = 10.156.0.3

#HomeWork 4
##Scripts to install ruby, mongodb and deploy app
1. install_ruby.sh for install ruby
2. install_mongodb.sh for install mongodb
3. deploy.sh for deploy app

##Install&Deploy startup command and script
startup.sh for install and deploy
Command:
gcloud compute instances create reddit-app-4 \
  --boot-disk-size=10GB \
  --metadata=startup-script-url=gs://mandrosov/startup.sh \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure

##Firewall rule for app
gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --source-tags=puma-server --source-ranges=0.0.0.0/0 --description="For test app"

testapp_IP = 35.210.209.113
testapp_port = 9292
