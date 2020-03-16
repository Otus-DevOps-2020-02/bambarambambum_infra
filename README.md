#SSH to GCP host
1. The way to connect in one command to the "little-1" host
ssh -J mikh_androsov@35.242.221.114 mikh_androsov@little-1

2. Another way to connect to the host by alias
1) Set configuration ~/.ssh/config

Host bastion
  HostName 35.242.221.114
  User mikh_androsov
Host little
  HostName 10.156.0.3
  User mikh_androsov
  ProxyJump bastion

2) Use the command "ssh little"
