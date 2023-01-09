#!/bin/bash
# 
# functions for setting up app frontend


#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_serverjs_setup() {
  print_banner
  printf "${WHITE} 💻 Criando server.js (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2


sudo su - root << EOF

cat > /home/deploy/izing.io/frontend/server.js << 'END'
// simple express server to run frontend production build;
const express = require('express')
const path = require('path')
const app = express()
app.use(express.static(path.join(__dirname, 'dist/pwa')))
app.get('/*', function (req, res) {
  res.sendFile(path.join(__dirname, 'dist/pwa', 'index.html'))
})
app.listen(3333)


END

EOF

  sleep 2
}




#######################################
# installed node packages
# Arguments:
#   None
#######################################
frontend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing.io/frontend
  npm install
EOF

  sleep 2
}

#######################################
# compiles frontend code
# Arguments:
#   None
#######################################
frontend_node_quasar() {
  print_banner
  printf "${WHITE} 💻 Instalando Quasar...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy/izing.io/frontend
  npm install -g @quasar/cli

EOF

  sleep 2
}


#######################################
# compiles frontend code
# Arguments:
#   None
#######################################
frontend_node_build() {
  print_banner
  printf "${WHITE} 💻 Compilando o código do frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing.io/frontend
  quasar build -P -m pwa

EOF

  sleep 2
}



#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing.io
  git pull
  cd /home/deploy/izing.io/frontend
  npm install
  quasar build -P -m pwa


EOF

  sleep 2
}


#######################################
# sets frontend environment variables
# Arguments:
#   None
#######################################
frontend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/izing.io/frontend/.env
URL_API=${backend_url}
FACEBOOK_APP_ID='seu ID facebook'
[-]EOF
EOF

  sleep 2
}


#######################################
# starts frontend using pm2 in
# production mode.
# Arguments:
#   None
#######################################


frontend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing.io/frontend
  pm2 start server.js --name izing.io-frontend
  pm2 save
EOF

  sleep 2
}




#######################################
# sets up nginx for frontend
# Arguments:
#   None
#######################################
frontend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  frontend_hostname=$(echo "${frontend_url/https:\/\/}")
  uri=$uri
sudo su - root << EOF

cat > /etc/nginx/sites-available/izing.io-frontend << 'END'
server {
  server_name $frontend_hostname;
  
    location / {
    proxy_pass http://127.0.0.1:3333;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}


END

ln -s /etc/nginx/sites-available/izing.io-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}
