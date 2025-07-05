#!/bin/bash

sudo docker pull nibhav/pet_store_app_01:latest
sudo docker stop pet_store_app_01 || true
sudo docker rm pet_store_app_01 || true
sudo docker run -d --name pet_store_app_01 -p 80:5000 nibhav/pet_store_app_01:latest