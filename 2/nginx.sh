#!/bin/bash
sudo apt update -y
sleep 5
sudo apt install docker.io nginx -y
sleep 5
sudo systemctl status nginx
