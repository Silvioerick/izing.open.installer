#!/bin/bash
# 
# functions for setting up app admin frontend

#######################################
# installed node packages
# Arguments:
#   None
#######################################
admin-frontend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do Admin frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing.io/admin-frontend
  npm install
EOF

  sleep 2
}

#######################################
# compiles admin frontend code
# Arguments:
#   None
#######################################
admin-frontend_node_build() {
  print_banner
  printf "${WHITE} 💻 Compilando o código do Admin frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing.io/admin-frontend
  quasar build -P -m pwa

EOF

  sleep 2
}



#######################################
# updates admin frontend code
# Arguments:
#   None
#######################################
admin-frontend_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o Admin frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/izing.io
  git pull
  cd /home/deploy/izing.io/admin-frontend
  npm install
  quasar build -P -m pwa


EOF

  sleep 2
}


#######################################
# sets admin frontend environment variables
# Arguments:
#   None
#######################################
admin-frontend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (Admin frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/izing.io/admin-frontend/.env
URL_API=${backend_url}
URL_API2=${backend_url}
[-]EOF
EOF

  sleep 2
}

#######################################
# sets up nginx for admin frontend
# Arguments:
#   None
#######################################
admin-frontend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (Admin frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  admin_frontend_hostname=$(echo "${admin_frontend_url/https:\/\/}")
  uri=$uri
sudo su - root << EOF

cat > /etc/nginx/sites-available/izing.io-admin-frontend << 'END'
server {
  server_name $admin_frontend_hostname;
  listen 3004;
  root /home/deploy/izing.io/admin-frontend/dist/pwa;

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

ln -s /etc/nginx/sites-available/izing.io-admin-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}

#######################################
# sets up quasara conf for admin frontend
# Arguments:
#   None
#######################################
admin-frontend_quasarconf_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando Quasar Conf (Admin frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2
  admin_backend_url=$backend_url
sudo su - deploy << EOF

cat > /home/deploy/izing.io/admin-frontend/quasar.conf.js << 'END'
module.exports = function (ctx) {
  return {
     boot: [
      'vuelidate',
      'ccComponents'
    ],
    css: [
      'app.sass'
    ],
    extras: [
      'mdi-v5',
      'roboto-font', // optional, you are not bound to it
      'material-icons' // optional, you are not bound to it
    ],
    build: {
      env: ctx.dev ? {
              API: '$admin_backend_url:3000'
      }
        : {
                API: '$admin_backend_url'
        },
      vueRouterMode: 'hash', // available values: 'hash', 'history'
      extendWebpack (cfg) {
        cfg.module.rules.push({
          enforce: 'pre',
          test: /\.(js|vue)$/,
          loader: 'eslint-loader',
          exclude: /node_modules/,
          options: {
            devtool: 'source-map',
            preventExtract: true
          }
        })
        cfg.devtool = 'source-map'
      }
    },
    devServer: {
      https: false,
      open: true // opens browser window automatically
    },
    framework: {
      iconSet: 'material-icons', // Quasar icon set
      lang: 'pt-br',
      config: {
        dark: false
      },
      directives: ['Ripple', 'ClosePopup'],
      importStrategy: 'auto',
      plugins: ['Notify', 'Dialog']
    },
    animations: 'all', // --- includes all animations
    ssr: {
      pwa: false
    },
    pwa: {
      workboxPluginMode: 'GenerateSW', // 'GenerateSW' or 'InjectManifest'
      workboxOptions: {}, // only for GenerateSW
      manifest: {
        name: 'WChats',
        short_name: 'WChats',
        description: 'Bot Multi-atendimento para whatsapp',
        display: 'standalone',
        orientation: 'portrait',
        background_color: '#ffffff',
        theme_color: '#027be3',
        icons: [
          {
            src: 'icons/icon-128x128.png',
            sizes: '128x128',
            type: 'image/png'
          },
          {
            src: 'icons/icon-192x192.png',
            sizes: '192x192',
            type: 'image/png'
          },
          {
            src: 'icons/icon-256x256.png',
            sizes: '256x256',
            type: 'image/png'
          },
          {
            src: 'icons/icon-384x384.png',
            sizes: '384x384',
            type: 'image/png'
          },
          {
            src: 'icons/icon-512x512.png',
            sizes: '512x512',
            type: 'image/png'
          }
        ]
      }
    },

    cordova: {
    },
    capacitor: {
      hideSplashscreen: true
    },
    electron: {
      bundler: 'packager', // 'packager' or 'builder'
      packager: {
      },
      builder: {
        appId: 'WChats'
      },
      nodeIntegration: true,
      extendWebpack (/* cfg */) {
      }
    }
  }
}

END
EOF

  sleep 2
}

