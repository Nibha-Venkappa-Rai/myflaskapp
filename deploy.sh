#!/bin/bash

sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

#sudo docker pull nibhav/pet_store_app_01:latest
#sudo docker stop pet_store_app_01 || true
#sudo docker rm pet_store_app_01 || true
#sudo docker run -d --name pet_store_app_01 -p 80:5000 nibhav/pet_store_app_01:latest

IMAGE_NAME= "$1"
TAG_NAME= "$2"
CONTAINER_NAME= "pet_store_app_01"
HEALTHCHECK_URL= "http://16.170.221.115/health"

#Pulling new image
sudo docker pull $IMAGE_NAME:$TAG_NAME || { echo "Pull failed"; exit 1; }

#Tagging existing image as previous
if sudo docker ps -a --format '{{.Names}}' | grep -q $CONTAINER_NAME; then
    echo "Tagging current image as previous"
    CURRENT_IMAGE= $(sudo docker inspect --format '{{.Config.Image}}' $CONTAINER_NAME)
    sudo docker tag $CURRENT_IMAGE $IMAGE_NAME:previous
fi 

#Stopping current container
sudo docker stop $CONTAINER_NAME 2>/dev/null
sudo docker rm $CONTAINER_NAME 2>/dev/null

#Starting new container
sudo docker run -d --name $CONTAINER_NAME -p 80:5000 $IMAGE_NAME:$TAG_NAME

#app boot wait time setting
sleep 5

HTTP_STATUS=$(curl -s -o /dev/null -w"%{http_code}" $HEALTHCHECK_URL)

if [ $HTTP_STATUS -eq 200]; then
    echo "App deployed successfully"
else
    sudo docker stop $CONTAINER_NAME
    sudo docker rm $CONTAINER_NAME
    sudo docker run -d --name $CONTAINER_NAME -p 80:5000 $IMAGE_NAME:previous
    echo "Reverted to previous state"
    exit 1
fi



