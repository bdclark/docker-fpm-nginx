#!/bin/sh
set -e

echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/01-date_timezone.ini

if [ "$PHP_ENABLE_OPCACHE" = true ]; then
  echo "zend_extension=opcache.so" > $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini
fi

if [ "$PHP_ENABLE_XDEBUG" = true ]; then
  echo "zend_extension=xdebug.so" > $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini
fi

# if running composer, support custom uid/gid and ssh
if [ "$1" = "composer" ]; then
  UID=${UID:-0}
  GID=${GID:-0}
  home=/root

  if [ "$UID" -ne "0" ]; then
    home=/home/composer
    addgroup -g $GID composer
    adduser -D -u $UID -h $home -G composer composer
  fi

  if test -f /ssh/id_rsa; then
    echo "ssh key detected, installing ssh..."
    apk add --no-cache openssh-client
    mkdir -p $home/.ssh
    cp /ssh/id_rsa $home/.ssh/id_rsa
    chmod 600 $home/.ssh/id_rsa
    test -f /ssh/known_hosts && ln -s /ssh/known_hosts $home/.ssh/
  fi

  chown -R $UID:$GID $home
  exec su-exec $UID:$GID "$@"
fi

exec "$@"
