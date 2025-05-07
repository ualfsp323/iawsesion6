#/bin/bash
set -x
#----------------------------------------------------

#----------------------------------------------------
# Variables de configuración 
#----------------------------------------------------

MYSQL_ROOT_PASSWORD=root

#----------------------------------------------------

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

