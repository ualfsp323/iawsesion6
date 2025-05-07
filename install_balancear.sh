#/bin/bash
set -x
#----------------------------------------------------

#----------------------------------------------------
# Variables de configuración 
#----------------------------------------------------

IP_SERVER=172.31.85.173
IP_SERVER2=172.31.94.212

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

# Activamos los siguientes módulos:
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp
a2enmod rewrite
a2enmod deflate
a2enmod headers
a2enmod proxy_balancer
a2enmod proxy_connect
a2enmod proxy_html
a2enmod lbmethod_byrequests

# Reiniciamos el servidor apache2
systemctl restart apache2

# Modificamos el archivo 000-default.conf para hacer el balanceador de nuestra pagina web

sed -i "s/172.31.85.173/$IP_SERVER/" /home/ubuntu/iaw-practica-05/000-default.conf
sed -i "s/172.31.94.212/$IP_SERVER2/" /home/ubuntu/iaw-practica-05/000-default.conf
cp 000-default.conf /etc/apache2/sites-available
systemctl restart apache2

# Realizams la instalacion de snapd
snap install core
snap refresh core

# Eliminamos instalaciones previas de certbot con apt
apt-get remove certbot

# Instalamos certbot con snap
snap install --classic certbot

# Solicitamos el certificado HTTPS
sudo certbot --apache -m $EMAIL_HTPPS --agree-tos --no-eff-email -d $DOMAIN