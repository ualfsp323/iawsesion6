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
# Instalacíon de la pila LEMP (Solución 1: Unix en la misma máquina)
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
cp conf/default_socket_unix /etc/nginx/sites-available/default
systemctl restart nginx


# Comprobacion
cp conf/info.php /var/www/html/

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

sed -i "s/Simple LAMP web app/Simple LAMP web app Fronted Nº2/" /var/www/html/index.php
