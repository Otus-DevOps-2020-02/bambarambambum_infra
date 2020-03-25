# bambarambambum_infra
bambarambambum Infra repository
# HomeWork 3 SSH to GCP host
1. The way to connect in one command to the "little-1" host ``` ssh -J mikh_androsov@35.242.221.114 mikh_androsov@little-1 ``` 2. Another way to connect to the host by alias * Set configuration ~/.ssh/config
> Host bastion
 > HostName 35.242.221.114
>  User mikh_androsov
>   ForwardAgent yes Host little HostName 10.156.0.3 User mikh_androsov ProxyJump bastion
* Use the command ```ssh little```
# Pritunl VPN configuration
> Host: little-1 (IP: 10.156.0.3) OS: Ubuntu 16.04 Installation script Pritunl: setupvpn.sh Address: https://35.242.221.114/ Login: pritunl Password: pritunl Configuration - Users and Organizations Organization: test Users: test
> PIN: 6214157507237678334670591556762 Servers Network: 192.168.233.0/24
>  Port: 12503/udp Configuration file for OpenVPN: cloud-bastion.ovpn
bastion_IP = 35.242.221.114 someinternalhost_IP = 10.156.0.3
# HomeWork 4
### Scripts to install ruby, mongodb and deploy app
1. install_ruby.sh for install ruby 2. install_mongodb.sh for install mongodb 3. deploy.sh for deploy app
### Install & Deploy startup command and script
startup.sh for install and deploy
 Command: ``` gcloud compute instances create reddit-app-4 \
  --boot-disk-size=10GB \
  --metadata=startup-script-url=gs://mandrosov/startup.sh \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure ```
### Firewall rule for app
``` gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --source-tags=puma-server --source-ranges=0.0.0.0/0 --description="For test app" ``` testapp_IP = 35.210.209.113 testapp_port = 9292
# HomeWork 5
### Task 1 - Template User Variables
File - ubuntu16.json Block "variables": ``` "variables": {
        "my_project_id": "",
        "my_source_image_family": "",
        "my_machine_type": "",
      },
``` Block "builders" ``` "project_id": "{{user `my_project_id`}}", "source_image_family": "{{user `my_source_image_family`}}", "machine_type": "{{user `my_machine_type`}}",
 ``` File with variable values - variables.json.example ``` {
      "my_project_id": "projectus",
      "my_source_image_family": "ubuntu-38.10-lts",
      "my_machine_type": "high-perfomance inst",
}
``` How to check configuration: ```packer validate -var-file=./variables.json ./ubuntu16.json```
### Task 2 - Another option to block "builder" for GCP
File - ubuntu16.json, block "builders" ``` "image_description": "My test app image", "disk_type": "pd-standart", "disk_size": "10", "network":"default", "tags": ["{{user `my_firewall_rule`}}"] ``` Add new line in to block
"variables" ```"my_firewall_rule": ""``` Add new line and value in to variables.json.example ```"my_firewall_rule": "my-rule"``` How to check configuration: ```packer validate -var-file=./variables.json ./ubuntu16.json```
### Task 3 - Immutable infrastructure
1. Create files/myapp.service to autostart an application
> [Unit] Description=MyApp After=network.target After=mongod.service [Service] Type=simple WorkingDirectory=/home/mikh_androsov/reddit/ ExecStart=/usr/local/bin/pumactl start [Install] WantedBy=multi-user.target
2. Create and fill "immutable.json". Take as a template ubuntu16.json Add new lines to block "provisioners". Important! They must be first on the list. ``` {
    "type": "file",
    "source": "./files/myapp.service",
    "destination": "/home/mikh_androsov/myapp.service"
},
``` Change image-family name to "reddit-full" ```"image_family": "reddit-full"``` 3. Modify scripts/deploy.sh, add lines:
>sudo mv ../myapp.service /etc/systemd/system/ sudo systemctl enable myapp.service sudo systemctl start myapp.service
4. Create and fill "variables_full.json". Copy variables.json 5. How to check configuration: ```packer validate -var-file=./variables_full.json ./immutable.json```
### Task 4 - Starting a virtual machine
1. Create script config-scripts/create-redditvm.sh ``` bin/bash gcloud compute instances create instance-full-3 \
  --boot-disk-size=10GB \
  --image-family reddit-full \
  --machine-type=g1-small \
  --tags default-puma-server \
  --restart-on-failure ```
2. Copy IP into web-browser and check our application
