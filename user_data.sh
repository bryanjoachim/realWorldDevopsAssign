#!/bin/bash

apt update -y
apt install -y nginx curl

curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs


cat <<EOF > /var/www/html/app.js
const http = require('http');
const port = 80;
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.end('Hello from Terraform provisioned Node.js app!');
});
server.listen(port);
EOF


npm install -g pm2
pm2 start /var/www/html/app.js
pm2 startup systemd
pm2 save

