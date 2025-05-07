#/bin/bash
set -x
#----------------------------------------------------

#----------------------------------------------------
# Variables de configuración 
#----------------------------------------------------
# Configuramos 
IP_MYSQL=172.31.89.112

EMAIL_HTPPS=f.s.p282002@gamil.com
DOMAIN=fspcorp.ddns.net
#----------------------------------------------------

#----------------------------------------------------
# Instalacíon de la pila LAMP
#----------------------------------------------------
# Actualizamos el sistema
apt update
apt upgrade -y

# Instalamos El Apache2
apt install apache2 -y
 

# Instalamos php-mysql
apt install php libapache2-mod-php php-mysql -y

# Reiniciamos el servidor apache2
systemctl restart apache2



#----------------------------------------------------
# Instalacíon de herramientas adicionales 
#----------------------------------------------------
# Herramienta: Adminer
cd /var/www/html
mkdir adminer
cd adminer
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php
mv adminer-4.8.1-mysql.php index.php

# Actualizamos el propietario y el grupo del directorio /var/www/html
chown www-data:www-data /var/www/html -R 




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

#----------------------------------------
# Configuramos HTPPS
#----------------------------------------


# Realizams la instalacion de snapd
#snap install core
#snap refresh core

# Eliminamos instalaciones previas de certbot con apt
# apt-get remove certbot

# Instalamos certbot con snap
# snap install --classic certbot

# Solicitamos el certificado HTTPS
# sudo certbot --apache -m $EMAIL_HTPPS --agree-tos --no-eff-email -d $DOMAIN