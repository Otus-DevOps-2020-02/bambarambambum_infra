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
little-1_IP = 10.156.0.3
