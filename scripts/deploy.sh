#!/bin/bash

# Importamos el archivo de las variables que vamos a utilizar para los usuarios y contraseñas
source .env

# mostramos los comandos y finalizamos si hay error
set -ex

#Previamente borramos el archivo clonado de la aplicacion

rm -rf /tmp/iaw-practica-lamp

# Clonamos el repositorio de la aplicacion
git clone https://github.com/josejuansanchez/iaw-practica-lamp /tmp/iaw-practica-lamp

#Ahora llevamos el codigo fuente de la aplicacion a /var/www/html

mv /tmp/iaw-practica-lamp/src/* /var/www/html/

# CONFIGURAMOS EL ARCHIVO CONFIG.PHP
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/config.php
sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/config.php

#CONFIGURACION DEL MYSQL Y CREACION DE USUARIO.

#  hacemos una base de datos de ejemplo
mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<< "CREATE DATABASE $DB_NAME"

#Creamos un usuario
mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%'"


#Configuramos el script de QL con el nombre de la base de datos.()

sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql

#Creamos las tablas de la base de datos
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql

#configuramos el achivo config.php de la aplicacion web
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
sed -i "s/username_name_here/$DB_USER/" /var/www/html/config.php
sed -i "s/password_here/$DB_PASS/" /var/www/html/config.php

#modificar propietario y grupo
chown -R www-data:www-data  /var/www/html