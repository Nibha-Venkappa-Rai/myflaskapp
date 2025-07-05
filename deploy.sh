#!/bin/bash

sudo apt-get update
sudo apt-get install docker -y
sudo systemctl start docker
sudo systemctl enable docker

sudo docker pull nibhav/pet_store_app_01:latest
sudo docker stop pet_store_app_01 || true
sudo docker rm pet_store_app_01 || true
sudo docker run -d --name pet_store_app_01 -p 80:5000 nibhav/pet_store_app_01:latest