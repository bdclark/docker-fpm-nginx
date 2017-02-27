#!/usr/bin/with-contenv sh

echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/01-date_timezone.ini

if [ "$PHP_ENABLE_OPCACHE" = true ]; then
  echo "zend_extension=opcache.so" > $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini
fi

if [ "$PHP_ENABLE_XDEBUG" = true ]; then
  echo "zend_extension=xdebug.so" > $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini
fi
