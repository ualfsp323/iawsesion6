#/bin/bash
set -x
#----------------------------------------------------

#----------------------------------------------------
# Variables de configuración 
#----------------------------------------------------
# Configuramos 
IP_MYSQL=172.31.83.131

#----------------------------------------------------

#----------------------------------------------------
# Instalacíon de la pila LEMP (Solución 2: Socket TCP en la misma máquina)
#----------------------------------------------------
# Actualizamos el sistema
apt update
# apt upgrade -y

# Instalamos El servidor NGINX
apt install nginx -y

# Instalamos el php-fpm y php-mysql
apt install php-fpm -y
apt install php-mysql -y


# Configuración de Nginx
cp conf/default_socket_tcp /etc/nginx/sites-available/default

# Configuración de php-fmp
sed -i "s#/run/php/php7.4-fpm.sock#127.0.0.1:9000#" /home/ubuntu/iaw-practica-06/conf/www.conf
cp conf/www.conf /etc/php/7.4/fpm/pool.d 
systemctl restart php7.4-fpm

# Comprobacion
cp conf/info.php /var/www/html/

systemctl restart nginx

#--------------------------------------
# Despliege de la aplicacion web
#--------------------------------------
cd /var/www/html

# Clonamos el repositorio de la aplicación
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

#Movemos el codigo fuente de la aplicación al directorio /var/www/html

mv iaw-practica-lamp/src/* /var/www/html


# Eliminamos el archivo index.html
rm /var/www/html/index.html

# Eliminamos el directorio del repositorio
rm -rf /var/www/html/iaw-practica-lamp

#Configuramos la dirección IP de MYSQL en el archivo de configuración
sed -i "s/localhost/$IP_MYSQL/" /var/www/html/config.php


# Cambiamos el propietario y el grupo
chown www-data:www-data /var/www/html -R 


#Cambiamos el nombre de la Homepage

sed -i "s/Simple LAMP web app/Simple LAMP web app Fronted Nº1/" /var/www/html/index.php

