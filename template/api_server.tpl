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

#Docker compose file to run GitLab container
sudo sh -c "cat << EOF > $GITLAB_HOME/docker-compose.yaml
---
version: '3.6'
networks:
  frontend:
services:
  web:
    image: 'gitlab/gitlab-ce:15.11.2-ce.0'
    restart: always
    hostname: 'gitlab.${domain_name}'
    container_name: 'gitlab'
    environment:
      GITLAB_ROOT_PASSWORD: '${gitlab_root_password}'
      GITLAB_OMNIBUS_CONFIG: |
        # Add any other gitlab.rb configuration here, each on its own line
        external_url 'https://gitlab.${domain_name}'
        # Renew every 10th day of the month at 00:00 UTC
        letsencrypt['enable'] = true
        letsencrypt['auto_renew'] = true
        letsencrypt['auto_renew_hour'] = '3'
        letsencrypt['auto_renew_minute'] = '0'
        letsencrypt['auto_renew_day_of_month'] = '*/7'
        letsencrypt['contact_emails'] = ['hiago@cloudplusplus.nl']
        nginx['redirect_http_to_https'] = true
        gitlab_rails['lfs_enabled'] = true
        gitlab_rails['gitlab_shell_ssh_port'] = 22
        gitlab_rails['monitoring_whitelist'] = ['${vpc_cidr}']
        gitlab_rails['prometheus_address'] = 'localhost:9090'
        # Configure headers for outgoing email.
        gitlab_rails['gitlab_email_enabled'] = true
        gitlab_rails['gitlab_email_from'] = 'no-reply@${domain_name}'
        gitlab_rails['gitlab_email_display_name'] = 'GitLab'
        gitlab_rails['gitlab_email_reply_to'] = 'no-reply@${domain_name}'
        # Send outgoing email via the SMTP container:
        gitlab_rails['smtp_enable'] = true
        gitlab_rails['smtp_address'] = '${smtp_address}'
        gitlab_rails['smtp_port'] = ${smtp_port}
        gitlab_rails['smtp_user_name'] = '${smtp_user_name}'
        gitlab_rails['smtp_password'] = '${smtp_password}'
        gitlab_rails['smtp_tls'] = false
        # Limit backup lifetime to 7 days (604800 seconds):
        gitlab_rails['backup_keep_time'] = 604800
    ports:
      - '80:80'
      - '443:443'
      - '22:22'
      - '5050:5050'
    networks:
      - frontend
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
EOF"

#Execute docker compose to run Api Server container
cd $GITLAB_HOME && sudo /usr/local/bin/docker-compose up -d
