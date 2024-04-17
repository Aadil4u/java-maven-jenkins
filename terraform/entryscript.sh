#!/bin/bash
sudo yum update -y && sudo yum install docker -y
sudo systemctl start docker
sudo usermod -aG docker ec2-user
docker run -d -p 8080:80 nginx

sudo curl -SL https://github.com/docker/compose/releases/download/v2.26.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
