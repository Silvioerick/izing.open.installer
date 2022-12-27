#!/bin/bash
# 
# functions for setting up app frontend

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
  listen 3003;
  root /home/deploy/izing.io/frontend/dist/pwa;

  add_header X-Frame-Options "SAMEORIGIN";
  add_header X-XSS-Protection "1; mode=block";
  add_header X-Content-Type-Options "nosniff"; 
  
  index index.html;
  charset utf-8;
  location / {
    try_files $uri $uri/ /index.html;
  }

  access_log off;

}

END

ln -s /etc/nginx/sites-available/izing.io-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}
