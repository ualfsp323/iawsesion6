# iaw-practica-05
### Práctica 1 de IAW
<div id='id6' />

### **Por Franco Sergio Pereyra 2º ASIR**
# **Índice**
* 1.- [ Frontend](#id1)
* 2.- [Backend](#id3)
* 3.- [Balanceador de carga con Apache](#id5)

<div id='id1' />

## 1.- Frontend (Añadimos solamente el servidor)
```bash
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
```
### 1.1.- Instalamos la pila LAMP 
```bash
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
```
### 1.2.- Instalamos las herramientas adicionales
```bash
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
```
### 1.3.- Desplegamos la aplicación web
```bash
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
```

<div id='id3' />

## 2.- Backend (Añadimos solamente la base de Datos)
```bash
#/bin/bash
set -x
#----------------------------------------------------

#----------------------------------------------------
# Variables de configuración 
#----------------------------------------------------

MYSQL_ROOT_PASSWORD=root

#----------------------------------------------------
```
### 2.1.- Instalamos la pila LAMP(Solo el mysql)
```bash
#----------------------------------------------------
# Instalacíon de la pila LAMP
#----------------------------------------------------
# Actualizamos el sistema
apt update
apt upgrade -y


# Instalamos MySQL Server
apt install mysql-server -y

# Cambiamos la contraseña del usuario root
# mysql <<< "ALTER USER root@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASSWORD';"

# Configuramos MySQL para aceptar conexiones desde cualquier interfaz de red
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciamos el servicio de MySQL
systemctl restart mysql
```
### 2.2.- Desplegamos la aplicación web
```bash
#--------------------------------------
# Despliege de la aplicacion web
#--------------------------------------
cd /var/www/html

# Clonamos el repositorio de la aplicación
rm -rf /var/www/html/iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

#Movemos el codigo fuente de la aplicación al directorio /var/www/html


# Importamos el script de basde de datos
mysql -u root -p$MYSQL_ROOT_PASSWORD < /var/www/html/iaw-practica-lamp/db/database.sql

# Eliminamos el directorio del repositorio
rm -rf /var/www/html/iaw-practica-lamp
```

<div id='id5' />

## 3.- Balanceador de carga con Apache

```bash
#/bin/bash
set -x
#----------------------------------------------------

#----------------------------------------------------
# Variables de configuración 
#----------------------------------------------------

IP_SERVER=172.31.83.70
IP_SERVER2=172.31.92.139


EMAIL_HTPPS=f.s.p282002@gamil.com
DOMAIN=fspcorp.ddns.net
#----------------------------------------------------
```
### 3.1.-Intalamos apache y los modulos de a2enmod
```bash
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
```
### 3.2.-Modificamos el archivo 000-default.conf para hacer el balanceador de nuestra pagina web

```bash
sed -i "s/100.26.201.158/$IP_SERVER/" /home/ubuntu/iaw-practica-05/000-default.conf
sed -i "s/184.72.166.199/$IP_SERVER2/" /home/ubuntu/iaw-practica-05/000-default.conf
cp 000-default.conf /etc/apache2/sites-available
systemctl restart apache2
```
### 3.3.-Instalamos Cerbot
```bash
# Realizams la instalacion de snapd
snap install core
snap refresh core

# Eliminamos instalaciones previas de certbot con apt
apt-get remove certbot

# Instalamos certbot con snap
snap install --classic certbot

# Solicitamos el certificado HTTPS
sudo certbot --apache -m $EMAIL_HTPPS --agree-tos --no-eff-email -d $DOMAIN
```
[Volver hacia arriba](#id6)
