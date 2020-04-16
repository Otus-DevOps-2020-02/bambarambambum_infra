# bambarambambum_infra
bambarambambum Infra repository
# HomeWork 3
1. The way to connect in one command to the "little-1" host ``` ssh -J mikh_androsov@35.242.221.114 mikh_androsov@little-1 ``` 2. Another way to connect to the host by alias * Set configuration ~/.ssh/config
```
Host bastion
HostName 35.242.221.114
User mikh_androsov
ForwardAgent yes

Host little
HostName 10.156.0.3
User mikh_androsov
ProxyJump bastion
```
* Use the command ```ssh little```
# Pritunl VPN configuration
```
Host: little-1 (IP: 10.156.0.3)
OS: Ubuntu 16.04
Installation script Pritunl: setupvpn.sh
Address: https://35.242.221.114/
Login: pritunl Password: pritunl
Configuration -
	Users and Organizations Organization:
    	test Users: test
		PIN: 6214157507237678334670591556762
    Servers Network: 192.168.233.0/24
	Port: 12503/udp
Configuration file for OpenVPN: cloud-bastion.ovpn
```
bastion_IP = 35.242.221.114

someinternalhost_IP = 10.156.0.3

# HomeWork 4
### Scripts to install ruby, mongodb and deploy app
1. install_ruby.sh for install ruby
2. install_mongodb.sh for install mongodb
3. deploy.sh for deploy app
### Install & Deploy startup command and script
startup.sh for install and deploy

Command:
 ``` gcloud compute instances create reddit-app-4 \
  --boot-disk-size=10GB \
  --metadata=startup-script-url=gs://mandrosov/startup.sh \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure
```
### Firewall rule for app
```
gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --source-tags=puma-server --source-ranges=0.0.0.0/0 --description="For test app"
```
testapp_IP = 35.210.209.113

testapp_port = 9292
# HomeWork 5
### Task 1 - Template User Variables
File - ubuntu16.json
Block "variables":
```
"variables": {
        "my_project_id": "",
        "my_source_image_family": "",
        "my_machine_type": "",
      },
```
Block "builders"
```
"project_id": "{{user `my_project_id`}}", "source_image_family": "{{user `my_source_image_family`}}", "machine_type": "{{user `my_machine_type`}}",
 ```
 File with variable values - variables.json.example
 ``` {
      "my_project_id": "projectus",
      "my_source_image_family": "ubuntu-38.10-lts",
      "my_machine_type": "high-perfomance inst",
}
```
How to check configuration: ```packer validate -var-file=./variables.json ./ubuntu16.json```
### Task 2 - Another option to block "builder" for GCP
File - ubuntu16.json, block "builders"
```
"image_description": "My test app image",
"disk_type": "pd-standart",
"disk_size": "10",
"network":"default",
"tags": ["{{user `my_firewall_rule`}}"]
```
Add new line in to block
"variables"
```
"my_firewall_rule": ""
```
Add new line and value in to variables.json.example
```
"my_firewall_rule": "my-rule"
```
How to check configuration:
```packer validate -var-file=./variables.json ./ubuntu16.json```

### Task 3 - Immutable infrastructure
1. Create files/myapp.service to autostart an application
```
[Unit]
Description=MyApp
After=network.target
After=mongod.service
[Service] Type=simple
WorkingDirectory=/home/mikh_androsov/reddit/
ExecStart=/usr/local/bin/pumactl start
[Install]
WantedBy=multi-user.target
```
2. Create and fill "immutable.json". Take as a template ubuntu16.json
Add new lines to block "provisioners". Important! They must be first on the list.
```
{
    "type": "file",
    "source": "./files/myapp.service",
    "destination": "/home/mikh_androsov/myapp.service"
},
```
Change image-family name to "reddit-full" ```"image_family": "reddit-full"```
3. Modify scripts/deploy.sh, add lines:
```
sudo mv ../myapp.service /etc/systemd/system/
sudo systemctl enable myapp.service
sudo systemctl start myapp.service
```
4. Create and fill "variables_full.json". Copy variables.json
5. How to check configuration: ```packer validate -var-file=./variables_full.json ./immutable.json```
### Task 4 - Starting a virtual machine
1. Create script config-scripts/create-redditvm.sh
```
bin/bash
gcloud compute instances create instance-full-3 \
  --boot-disk-size=10GB \
  --image-family reddit-full \
  --machine-type=g1-small \
  --tags default-puma-server \
  --restart-on-failure
  ```
2. Copy IP into web-browser and check our application
# HomeWork 6
### Task 1
Define the input variable for the private key
* variables.tf
```
variable private_key_path {
  description = "Path to the private key used for ssh access"
}
```
* terraform.tfvars.example
```
private_key_path = "~/.ssh/appuser"
```
Define an input variable to set the zone with default value
* variables.tf
```
variable "zone" {
  description = "Zone"
  default = "europe-west1-b"
}
```
* See terraform.tfvars.example to see the rest of the variables
### Task 2
Add ssh keys of several users in project metadata
* variables.tf
```
variable "public_key" {
  type = "list"
  description = "Public Key in RSA"
  default = ["appuser:ssh-rsa AAAAB3NzaC1yc2EAAFADAQABDDDBAQC3ZGfEhcYLORqG4R8fYssFdXYmSOsw6HjM1rfqc9zS4golKhrCz+OXM0vQ3XCPraA+msD2N0MY88CI9m0LjkN1s+qY4AcEmcepeIg/IMqJXG/IdazVA7tDFD6/TMlgjXC9dDAkrDa/p/MuW113GHWkd89N+T5dGsirsW3nA7yDmJwJB+HFH//mY4ZUwNPqKJE0MilnSBLt+7rACe1jXFbNfrYMgXNoGWybUwnXDv8LusOHnO4+sDnVxy4NN6kKwHTSRDA4SYrGe0LsBwK5xY0ji5RM0jUq+NLTRcXeAOqP2zLfUM4wLn1+Js9vOYLjefQQdHqCPv8ygnyIWjAceLlX appuser"]
}
```
* terraform.tvfars.example
```
public_key = [
    "appuser:ssh-rsa ASSAB3NzaC1yc3CBBBBDAQABAAABAQC3ZGfEhcYLORqG4R8fYssFdXYmSOsw6HjM1rfqc9zS4golKhrCz+OXM0vQ3XCPraA+msD2N0MY88CI9m0LjkN1s+qY4AcEmcepeIg/IMqJXG/IdazVA7tDFD6/TMlgjXO9dDAkrDa/p/MuW113jHWkd89N+T5dGsirsRDnA7yDmJwJB+HFH//mY4ZUwNPqKJE0MilnSBLt+7rACe1jXFbNfrYMgXNoGWybUwnXDv8LusOHnO4+sDnVxy4NN6kKwHT6RDx4SYrGe0LsBwK5xY0ji5RM0jUq+NLTRcXeAOqP2zLfUM4wLn1+Js9vOYLjefQQdHqCPv8ygnyIWjAceLlX appuser",
    "appuser1:ssh-rsa ASSAB3NzaC1yc3CBBBBDAQABAAABAQC3ZGfEhcYLORqG4R8fYssFdXYmSOsw6HjM1rfqc9zS4golKhrCz+OXM0vQ3XCPraA+msD2N0MY88CI9m0LjkN1s+qY4AcEmcepeIg/IMqJXG/IdazVA7tDFD6/TMlgjXO9dDAkrDa/p/MuW113jHWkd89N+T5dGsirsRDnA7yDmJwJB+HFH//mY4ZUwNPqKJE0MilnSBLt+7rACe1jXFbNfrYMgXNoGWybUwnXDv8LusOHnO4+sDnVxy4NN6kKwHT6RDx4SYrGe0LsBwK5xY0ji5RM0jUq+NLTRcXeAOqP2zLfUM4wLn1+Js9vOYLjefQQdHqCPv8ygnyIWjAceLlX appuser1",
    "appuser2:ssh-rsa ASSAB3NzaC1yc3CBBBBDAQABAAABAQC3ZGfEhcYLORqG4R8fYssFdXYmSOsw6HjM1rfqc9zS4golKhrCz+OXM0vQ3XCPraA+msD2N0MY88CI9m0LjkN1s+qY4AcEmcepeIg/IMqJXG/IdazVA7tDFD6/TMlgjXO9dDAkrDa/p/MuW113jHWkd89N+T5dGsirsRDnA7yDmJwJB+HFH//mY4ZUwNPqKJE0MilnSBLt+7rACe1jXFbNfrYMgXNoGWybUwnXDv8LusOHnO4+sDnVxy4NN6kKwHT6RDx4SYrGe0LsBwK5xY0ji5RM0jUq+NLTRcXeAOqP2zLfUM4wLn1+Js9vOYLjefQQdHqCPv8ygnyIWjAceLlX appuser2",
    "appuser3:ssh-rsa ASSAB3NzaC1yc3CBBBBDAQABAAABAQC3ZGfEhcYLORqG4R8fYssFdXYmSOsw6HjM1rfqc9zS4golKhrCz+OXM0vQ3XCPraA+msD2N0MY88CI9m0LjkN1s+qY4AcEmcepeIg/IMqJXG/IdazVA7tDFD6/TMlgjXO9dDAkrDa/p/MuW113jHWkd89N+T5dGsirsRDnA7yDmJwJB+HFH//mY4ZUwNPqKJE0MilnSBLt+7rACe1jXFbNfrYMgXNoGWybUwnXDv8LusOHnO4+sDnVxy4NN6kKwHT6RDx4SYrGe0LsBwK5xY0ji5RM0jUq+NLTRcXeAOqP2zLfUM4wLn1+Js9vOYLjefQQdHqCPv8ygnyIWjAceLlX appuser3"
]
```
* main.tf
```
resource "google_compute_project_metadata_item" "ssh-keys" {
  key   = "ssh-keys"
  value = "${join("\n", var.public_key)}"
}
```
### Task 3
Add the ssh key in the web interface for the appuser_web user to the project metadata
* Use the command
```
terraform apply
```
Since this key is not described in main.tf, terraform offers us to remove it
* Solution:
1. Add user ssh key appuser_web
2. Agree to terraform and remove ssh key
### Task 4
* Create new file lb.tf. For the template we take main.tf. What we added new.
```
// 9292 check
resource "google_compute_http_health_check" "tcp-9292-connect" {
  name               = "tcp-9292-connect"
  description        = "Check app health"
  request_path       = "/"
  port               = var.port_app
  check_interval_sec = 10
  timeout_sec        = 5
}

// Resource pool
resource "google_compute_target_pool" "app-pool" {
  name             = "app-pool"
  region           = var.region
  instances = google_compute_instance.app.*.self_link
  health_checks = [
    google_compute_http_health_check.tcp-9292-connect.name
  ]
}

// Forwarding rule
resource "google_compute_forwarding_rule" "lb" {
  name                  = "app-pool-lb"
  target                = google_compute_target_pool.app-pool.self_link
  port_range            = "9292"
}
```
* variables.tf
```
variable "port_app" {
  description = "App port"
  default = "9292"
}
```
* outputs.tf
```
output "app_external_ip" {
  value = google_compute_instance.app[*].network_interface[0].access_config[0].nat_ip
}
output "app_lb_ip" {
  value = google_compute_forwarding_rule.lb.ip_address
}
```
* How to do more instances. lb.tf
```
resource "google_compute_instance" "app" {
  count = 2
  name = "reddit-app-${count.index}"
  ...
  }
  ```
  * Checking the application. Go to the ip address from the output variable app_lb_ip:9292
 # HomeWork 7
 ### Task 1
 We configure the storage of the state file as follows:
 * Create backend.tf
```
terraform {
  backend "gcs" {
    bucket = "my-homework7-test-bucket"
    prefix = "prod"
  }
}
```
Use the following command to apply backend settings
```
terraform init
```
Now we can apply the configuration
```
terraform apply
```
### Task 2
Application deployment
* We need to make a template file for our application along the following path /modules/app/files/puma.tpl
 ```
 [Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=mikh_androsov
Environment=DATABASE_URL=${mongo_ip}
WorkingDirectory=/home/mikh_androsov/reddit
ExecStart=/bin/bash -lc 'puma'
Restart=always

[Install]
WantedBy=multi-user.target
 ```
 Declare an empty variable in the file /modules/app/files/variables.tf

  ```
 variable "mongo_ip" {}
 ```
 Add a provisioning block in the file /modules/app/files/main.tf
  ```
 // Provision
  provisioner "file" {
    content      = templatefile("${path.module}/files/puma.tpl", {
      mongo_ip = var.mongo_ip
      })
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}
 ```
 Add the output variable with external IP address to the db module in the /modules/db/outputs.tf file
  ```
 output "db_ip" {
  value = google_compute_instance.db.network_interface.0.access_config.0.nat_ip
}
 ```
  ```
We need to transfer the IP address value from the db module to the app module. Edit /prod/main.tf
 module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  zone            = var.zone
  mongo_ip        = module.db.db_ip
  app_disk_image  = var.app_disk_image
}
 ```
Now we can apply the configuration
```
terraform init
terraform apply
```
# HomeWork 8
 ### Task 1
 At the initial launch of the  ```ansible-playbook clone.yml ``` command, the repository was already cloned, which the ensemble reports to us about.
After deleting the folder and re-executing the command, the module thinks that its action has changed something and writes changed = 1
### Task 2
Create an Inventory.json dynamic inventory file
 ```
{
        "reddit-app": {
                "hosts": ["35.210.209.113"]
        },
        "reddit-db": {
                "hosts": ["35.210.47.157"]
        }
}
  ```
Now we need a script that will generate it
```
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
```
We check its work with the following command
```
ansible all -i script.sh -m ping
```
Now in the file ansible.cfg specify the path to the script
```
[defaults]
inventory = ./script.sh
```
# HomeWork 9 - Ansible-2
### Task 1
For dynamic provisioning, I select the gcp_compute plugin.
Why? I tried using this https://github.com/adammck/terraform-inventory and this https://github.com/express42/terraform-ansible-example/blob/master/ansible/terraform.py scripts. The first script returns empty values. The second script did not work for me.
Let's start
1) The GCP modules require both the requests and the google-auth libraries to be installed.
```
pip install requests google-auth
```
2) Now we need GCE JSON credentials. We generate them according to this instruction https://support.google.com/cloud/answer/6158849?hl=en&ref_topic=6262490#serviceaccounts
3) Activate the plugin in ansible.cfg
```
[inventory]
enable_plugins = gcp_compute
```
4) Now create the inventory file inventory.gcp.yml
```
plugin: gcp_compute
projects:
  - my_project_name
keyed_groups: # group by name
  - key: name
hostnames: # get external IP
  - public_ip
filters: []
auth_kind: serviceaccount # Creds
service_account_file: /home/uadmin/project.json
```
5) Check how it's work
```
ansible-inventory -i inventory.gcp.yml --graph
```
```
@all:
  |--@_reddit_app:
  |  |--35.210.47.157
  |--@_reddit_db:
  |  |--35.210.231.163
  |--@ungrouped:
  ```
6) Change the hostname in the app.yml db.yml and deploy.yml files to those specified in the output (_reddit_app and _reddit_db)
7) Check playbook
 ```
ansible-playbook --inventory-file=inventory.gcp.yml site.yml --check
```
```
 PLAY RECAP *******************************************************************************************************
35.210.231.163             : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
35.210.47.157              : ok=9    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
8) Use playbook
```
ansible-playbook --inventory-file=inventory.gcp.yml site.yml
```
```
PLAY RECAP *******************************************************************************************************
35.210.231.163             : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
35.210.47.157              : ok=9    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
### Task 2
1) Build images
```
packer build var-file=./packer/variables.json ./packer/app.json
...
Build 'googlecompute' finished.
```
```
packer build var-file=./packer/variables.json ./packer/db.json
...
Build 'googlecompute' finished.
```
2) Re-create terraform
```
terraform destroy
```
```
terraform apply
...
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

app = 35.210.209.113
db = 35.206.137.133
```
3) Play playbook
```
ansible-playbook site.yml
```
```
PLAY RECAP ********************************************************************************************************
35.206.137.133             : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
35.210.209.113             : ok=9    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
# HomeWork 9 - Ansible-3
### Task 1
1) Declaring variables in stage and prod
```
db_host: 35.210.209.113
port: 80
server_name: reddit
proxy_pass: http://35.210.47.157:9292
```
2) Call the role jdauphant.nginx with a minimum settings in the app.yml playbook
```
    roles:
    - app
    - role: jdauphant.nginx
      nginx_sites:
        default:
        - listen {{ port }}
        - server_name {{ server_name }}
        - |
          location / {
             proxy_pass {{ proxy_pass }};
          }
```
3) Run the playbook. If you run the test, it will crash with an error, because real changes do not occur, and some actions require the existence of files.
```
ansible-playbook playbooks/site.yml
```
```
PLAY RECAP ********************************************************************************************************
35.210.209.113             : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
35.210.47.157              : ok=29   changed=19   unreachable=0    failed=0    skipped=17   rescued=0    ignored=0
```
### Task 2
1) As in the previous homework, configure dynamic inventory using the gcp_compute plugin. Add an line to ansible.cfg
```
[inventory]
enable_plugins = gcp_compute
```
2) We take the finished inventory.gcp.yml file and add it to the prod and stage folders
3) Since our host groups will be called differently, it is necessary to rename the app and db files in group_vars folder to _reddit_app and to _reddit_db (prod and stage)
4) In ansible.cfg specify the path to the inventory file
```
[defaults]
inventory = ./environments/stage/inventory.gcp.yml
```
5) Now we can check
```
ansible-playbook playbooks/site.yml --check
```
### Task 3
All checks can be found in the .travis.yml file. All checks were done using trytravis.

[![Build Status](https://travis-ci.com/bambarambambum/infra_trytravis.svg?branch=master)](https://travis-ci.com/bambarambambum/infra_trytravis)
