Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash

if [[ "$HOSTNAME" == "comment-api-server" ]]; then
  echo "Run once scripts already executed, exiting"
else
  #Set Server hostname
  hostnamectl set-hostname comment-api-server
__EOF__

  #Install Docker, Docker Compose and cloudwatch agent
  sudo yum update -y
  sudo yum install git vim amazon-cloudwatch-agent -y
  sudo amazon-linux-extras install docker -y
  sudo sh -c 'curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
  sudo chmod +x /usr/local/bin/docker-compose
  sudo usermod -aG docker ec2-user

  #Docker Volume
  printf "\nMounting docker volume...\n"
  sudo mkfs.xfs -L docker ${docker_data_vol}

  sudo sh -c 'echo "LABEL=docker /var/lib/docker xfs   defaults 0 0" >> /etc/fstab'
  sudo mount ${docker_data_vol} /var/lib/docker

  #Configuring Docker daemon to log rotation
  sudo sh -c 'cat << EOF >> /etc/docker/daemon.json
  {
    "log-driver": "json-file",
    "log-opts": {
    "max-size": "500m",
    "max-file": "3",
    "labels": "api_server_logs",
    "env": "prod"
    }
  }
EOF'

  #Enable and start Docker
  sudo systemctl start docker
  sudo systemctl enable docker

fi

#Docker compose file to run container
sudo sh -c "cat << EOF > $HOME/docker-compose.yaml
---
version: '3.6'
networks:
  frontend:
services:
  web:
    image: 'eemechs/comments-api-dev:v1.0.0'
    restart: always
    container_name: 'comments-api'
    ports:
      - '8000:8000'
    networks:
      - frontend
EOF"

#Execute docker compose to run Api Server container
cd $HOME && sudo /usr/local/bin/docker-compose up -d
