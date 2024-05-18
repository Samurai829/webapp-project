# adding repository and installing nginx		
apt update
apt install nginx -y
cat <<EOT > webapp
upstream webapp {

 server app01:8080;

}

server {

  listen 80;

location / {

  proxy_pass http://webapp;

}

}

EOT

mv vproapp /etc/nginx/sites-available/webapp
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/webapp /etc/nginx/sites-enabled/webapp

#INICIANDO SERVICIO NGINX Y FIREWALL
systemctl start nginx
systemctl enable nginx
systemctl restart nginx
