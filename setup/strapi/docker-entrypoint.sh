#!/bin/sh
set -ea

rm -rf /usr/local/bin/nodejs

/bin/sh -c ARCH= && dpkgArch="$(dpkg --print-architecture)"   && case "${dpkgArch##*-}" in     amd64) ARCH='x64';;     ppc64el) ARCH='ppc64le';;     s390x) ARCH='s390x';;     arm64) ARCH='arm64';;     armhf) ARCH='armv7l';;     i386) ARCH='x86';;     *) echo "unsupported architecture"; exit 1 ;;   esac   && set -ex   && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner  && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz"  && ln -s /usr/local/bin/node /usr/local/bin/nodejs   && node --version   && npm --version

if [ "$1" = "strapi" ]; then

  if [ ! -f "package.json" ]; then

    DATABASE_CLIENT=${DATABASE_CLIENT:-sqlite}

    EXTRA_ARGS=${EXTRA_ARGS}

    echo "Using strapi $(strapi version)"
    echo "No project found at /srv/app. Creating a new strapi project"

    DOCKER=true strapi new . \
      --dbclient=$DATABASE_CLIENT \
      --dbhost=$DATABASE_HOST \
      --dbport=$DATABASE_PORT \
      --dbname=$DATABASE_NAME \
      --dbusername=$DATABASE_USERNAME \
      --dbpassword=$DATABASE_PASSWORD \
      --dbssl=$DATABASE_SSL \
      $EXTRA_ARGS
  
  #copy server.js from /tmp to /srv/app/config/server.js
  
  cp /tmp/server.js /srv/app/config/server.js
  cp /tmp/plugins.js /srv/app/config/plugins.js

  elif [ ! -d "node_modules" ] || [ ! "$(ls -qAL node_modules 2>/dev/null)" ]; then

    echo "Node modules not installed. Installing..."

    if [ -f "yarn.lock" ]; then
      echo 'via yarn'
      yarn install
      
    else
      echo 'via npm'
      npm install
      npm run strapi install graphql

    fi

  fi

  echo 'installing graphql plugin...'
  yarn add @strapi/plugin-graphql

  strapi build

fi

echo "Starting your app..."

exec "$@"
