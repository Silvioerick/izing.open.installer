#!/bin/bash

get_frontend_url() {
  
  print_banner
  printf "${WHITE} 💻 Digite o IP Local da interface web (Exemplo IP:80 ou 8080):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " frontend_url
}

get_backend_url() {
  
  print_banner
  printf "${WHITE} 💻 Digite o IP da sua API(Exemplo IP:3000) :${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " backend_url
}

get_admin_frontend_url() {

  print_banner
  printf "${WHITE} 💻 Digite o IP da interface web Admin(Exemplo IP:3334):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " admin_frontend_url
}



get_deploy_pass() {

  print_banner
  printf "${WHITE} 💻 Digite uma senha para o Usuario Deploy:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " deploy_password
}




get_redis_pass() {

  print_banner
  printf "${WHITE} 💻 Digite uma senha para o Redis:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " redis_pass
}


get_db_name() {

  print_banner
  printf "${WHITE} 💻 Digite um nome para o Banco de Dados:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " db_name
}


get_db_user() {

  print_banner
  printf "${WHITE} 💻 Digite um usuario para o Banco de Dados:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " db_user
}


get_db_pass() {

  print_banner
  printf "${WHITE} 💻 Digite uma senha para o Banco de Dados:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " db_pass
}


get_urls() {
  
  get_frontend_url
  get_backend_url
  get_admin_frontend_url
  get_deploy_pass
  get_redis_pass
  get_db_name
  get_db_user
  get_db_pass
}

software_update() {
  
  frontend_update
  backend_update
  admin_frontend_update
}

inquiry_options() {
  
  print_banner
  printf "${WHITE} 💻 O que você precisa fazer?${GRAY_LIGHT}"
  printf "\n\n"
  printf "   [1] Instalar\n"
  printf "   [2] Atualizar\n"
  printf "\n"
  read -p "> " option

  case "${option}" in
    1) get_urls ;;

    2) 
      software_update 
      exit
      ;;

    *) exit ;;
  esac
}

