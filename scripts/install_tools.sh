#!/bin/bash

# Importamos el archivo de variables
source .env

# mostrar los comandos y finalizar si hay error
set -ex

# Actualiza los repositorios
apt update

# Actualizamos los paquetes
apt upgrade -y


#Configuramos las respuestas para la instalacion de phpMyAdmin
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections

# Instalamos el phpMyAdmin
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y



# Instalacion de Adminer
#  Creamos el direcctorio de Adminer
mkdir -p /var/www/html/adminer

# Instalamos el Adminer
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php -P /var/www/html/adminer

# Paso 3. Renombramos el nombre del script de adminer
mv /var/www/html/adminer/adminer-4.8.1-mysql.php /var/www/html/adminer/index.php

# Paso 4. Modificar el propietario y el grupo
chown -R www-data:www-data /var/www/html/adminer/index.php


#Instalacion de GoAccess
apt install goaccess -y

# Creamos un directorio estadisticas
mkdir -p /var/www/html/stats

# Ejecutamos GoAccess
goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize

chown -R www-data:www-data /var/www/