#!/bin/bash
#Get,install and start bundler app
echo "Download app..."
git clone -b monolith https://github.com/express42/reddit.git
echo "Install bundle..."
cd reddit && bundle install
echo "Start app..."
puma -d
status=$(ps aux | grep puma)
echo "Check app..."
$status
