#!/bin/bash
TARGET_DOMAIN_NAME=example.com
MAIL_ADDRESS=mail@example.com

apt update -y
apt install -y docker-compose nginx certbot

sysctl -w vm.max_map_count=262144

mkdir -p /opt/growi
cd /opt/growi
git clone https://github.com/Nia-TN1012/growi-docker-compose.git .

mkdir acme

cd docker-compose
cp nginx/conf/growi.conf /etc/nginx/sites-available/
sed -i -e "s/{DOMAIN_NAME}/${TARGET_DOMAIN_NAME}/g" /etc/nginx/sites-available/growi.conf
unlink /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/growi.conf /etc/nginx/sites-enabled/growi.conf

docker-compose build
docker-compose up -d
systemctl restart nginx

certbot certonly --agree-tos --webroot -w /opt/growi/acme -d ${TARGET_DOMAIN_NAME} -m ${MAIL_ADDRESS}

cp -f nginx/conf/growi_ssl.conf /etc/nginx/sites-available/growi.conf
sed -i -e "s/{DOMAIN_NAME}/${TARGET_DOMAIN_NAME}/g" /etc/nginx/sites-available/growi.conf
systemctl restart nginx