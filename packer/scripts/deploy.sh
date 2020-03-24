#!/bin/bash
#Get,install and start bundler app
echo "Download app..."
git clone -b monolith https://github.com/express42/reddit.git
echo "Install bundle..."
cd reddit && bundle install
mv ../start.sh .
mv ../stop.sh .
sudo mv ../myapp.service /etc/systemd/system/
echo "Start app..."
sudo systemctl enable myapp.service
sudo systemctl start myapp.service
