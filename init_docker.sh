#!/bin/bash
set -e

if ! [ -x "$(command -v docker)" ]; then
  echo 'docker is not installed, it will be installed soon'
  curl -fsSL https://get.docker.com | bash -s docker
  docker --version
fi

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'docker-compose is not installed, it will be installed soon'
  if [ ! -f "./docker-compose" ]; then
    curl -L https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-"$(uname -m)" >./docker-compose
  fi
  chmod +x ./docker-compose
  mv ./docker-compose /usr/local/bin/docker-compose
  docker-compose --version
fi

docker_dir=${1:-'/docker_root'}

if [ ! -d "$docker_dir" ]; then
  mkdir -p "$docker_dir"
fi

docker_compose_file=$docker_dir"/docker-compose.yml"

if [ ! -f "$docker_compose_file" ]; then
  echo "rewrite $docker_compose_file"
  cat >"$docker_compose_file" <<EOF
version: '3'
services:
  nginx:
    image: nginx:latest
    volumes:
      - $docker_dir/nginxconf:/opt/conf
    network_mode: host
    container_name: nginx
    # env_file:
    # - /opt/common.env
    restart: always
    environment:
      - SERVICE_NAME=nginx
    command:
      - sh
      - -c 
      - |
          if [ ! -d "/opt/conf" ]; then
            mkdir -p /opt/conf
          fi
          if [ ! -f "/opt/conf/nginx.conf" ]; then
            mv /etc/nginx/nginx.conf /opt/conf
          fi
          ln -snf /opt/conf/nginx.conf /etc/nginx/nginx.conf
          if [ ! -d "/opt/conf/conf.d" ]; then
            mkdir -p /opt/conf/conf.d
            mv /etc/nginx/conf.d/* /opt/conf/conf.d
          fi
          rm -rf /etc/nginx/conf.d
          ln -snf /opt/conf/conf.d /etc/nginx/conf.d
          if [ ! -d "/opt/conf/logs" ]; then
            mkdir -p /opt/conf/logs
            mv /var/log/nginx/* /opt/conf/logs
          fi
          rm -rf /var/log/nginx
          ln -snf /opt/conf/logs /var/log/nginx
          if [ ! -d "/opt/conf/html" ]; then
            mkdir -p /opt/conf/html
            mv /usr/share/nginx/html/* /opt/conf/html
          fi
          rm -rf /usr/share/nginx/html
          ln -snf /opt/conf/html /usr/share/nginx/html
          if [ ! -d "/opt/conf/nginxroot" ]; then
            mkdir -p /opt/conf/nginxroot
          fi
          rm -rf /nginxroot
          ln -snf /opt/conf/nginxroot /nginxroot
          nginx -t
          nginx -g 'daemon off;'
EOF
fi

docker-compose -f "$docker_compose_file" up -d

