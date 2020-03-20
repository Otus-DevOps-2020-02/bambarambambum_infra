#!/bin/bash
#Install Ruby and Bundler
echo "Start Install Ruby and Bundler"
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
rubyver=$(ruby -v)
bundlerver=$(bundler -v)
echo "Ruby: $rubyver installed!"
echo "Bundler: $bundlerver installed!"
