# CONFIGURACION DE PROYECTO
Es necesario instalar plugins para luego inicar Vagrant.

**VB GUEST**
        vagrant plugin install vagrant-vbguest
**HOSTMANAGER**
        vagrant plugin install vagrant-hostmanager

Luego de instalar los plugins necesarios usamos el comando `vagrant up` y esperamos a que termine el proceso de creacion y configuracion del entorno.

Ya inicializadas las maquinas virtuales, procedesmo a validar su estado y conexion.

`vagrant status`
Nos debe mostrar las maquinas en estado **RUNING** ya seguido de esto accedemos,

`vagrant ssh db01`
Seguido de esto debemos verificar la conexion `cat /etc/hosts` y luego hacemos `ping nombre -c 4` para validar su conexion, igualmente con `app01` accedemos y validamos conexion con los demas.

## CONFIGURACION DE DB01 CON MARIADB
Accedemos al VM db01 por SSH, instalamos las actualizaciones del sistema.

`sudo yum update -y`

Luego instalamos los paquetes de linux.
`sudo install epel-release -y`

Maria DB
`sudo yum install git mariadb-server -y`
Configuracion de mariadb-server
`sudo systemctl start mariadb`
`sudo systemctl enable mariadb`

Luego lanzamos MYSQL_SECURE_INSTALLATION.
`sudo mysql_secure_installation`

**NOTA: establezca la contraseña, EJ: admin123**
                Set root password? [Y/n] Y
                New password:
                Re-enter new password:
                Password updated successfully!
                Reloading privilege tables..
                ... Success!
 
                Remove anonymous users? [Y/n] Y
                ... Success!
                Normally, root should only be allowed to connect from 'localhost'. This
                ensures that someone cannot guess at the root password from the network.
                Disallow root login remotely? [Y/n] n
                
                Remove test database and access to it? [Y/n] Y

                Reload privilege tables now? [Y/n] Y
                ... Success

CONFIGURAMOS EL ENTORNO MYSQL.
 `mysql -u root -padmin123`

 `create database accounts;`
 
 `grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123';`
 
 `FLUSH PRIVILEGES;`

 `exit`

DESCARGAMOS EL CODIGO Y INICIALIZAMOS LA BASE DE DATOS.
`git clone -b main https://github.com/Samurai829/webapp-project.git`

Accedemos al directorio del REPOSITORIO.
`cd webapp-project`

Inicializamos el BACKUP.
`mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql`

Accedemos a MYSQL.
`mysql -u root -padmin123 accounts`

Verificamos la BASE DE DATOS.
`show tables;`
`exit;`

Reiniciamos Mariadb.
`sudo systemctl restart mariadb`

Iniciamos el Firewall y el permiso de acceso a MYSQL al PUERTO 3306.
`systemctl start firewalld`
`systemctl enable firewalld`
`firewall-cmd --get-active-zones`
`firewall-cmd --zone=public --add-port=3306/tcp --permanent`
`firewall-cmd --reload`
`systemctl restart mariadb`

## CONFIGURACION DE MC01 CON MEMCACHED
Accedemos al VM que contiene Memcache.
`vagrant ssh mc01`

Comprobamos la conexion de MC01 con `cat /etc/hosts/` y realizamos `ping` con los demas VM.

Realizamos la instalacion de paquetes.
`yum update -y`

**NOTA: Si no funciona la configuracion del Firewall**
USAR EL COMANDO
`sudo systemctl start firewalld`

Instalamos los recursos y inicializamos memcache en el PORT 11211.

`sudo dnf install epel-release -y`
`sudo dnf install memcached -y`
`sudo systemctl start memcached`
`sudo systemctl enable memcached`
`sudo systemctl status memcached`
`sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached`
`sudo systemctl restart memcached`

Iniciamos el FIREWALL y el permiso de acceso a MYSQL al PUERTO 3306.
`firewall-cmd --add-port=11211/tcp`
`firewall-cmd --runtime-to-permanent`
`firewall-cmd --add-port=11111/udp`
`firewall-cmd --runtime-to-permanent`
`sudo memcached -p 11211 -U 11111 -u memcached -d`

## CONFIGURACION DE RMQ01 CON RABBITMQ
Accedemos al VM con Rabbitmq
`vagrant ssh rmq01`

Comprobamos la conexion de MC01 con `cat /etc/hosts/` y realizamos `ping` con los demas VM.

Realizamos la instalacion de paquetes.
`yum update -y`

Luego instalamos los paquetes de linux.
`sudo install epel-release -y`

Instalamos dependencias.
`sudo yum install wget -y`
`cd /tmp/`
`dnf -y install centos-release-rabbitmq-38`
`dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server`
`systemctl enable --now rabbitmq-server`

Configuramos el acceso.
`sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'`
`sudo rabbitmqctl add_user test test`
`sudo rabbitmqctl set_user_tags test administrator`

Reiniciamos el servicio.
`sudo systemctl restart rabbitmq-server`

Iniciamos el FIREWALL y el permiso de acceso a RabbitMQ al PUERTO 5672.
`firewall-cmd --add-port=5672/tcp`
`firewall-cmd --runtime-to-permanent`
`sudo systemctl start rabbitmq-server`
`sudo systemctl enable rabbitmq-server`
`sudo systemctl status rabbitmq-server`

## CONFIGURACION DE APP01 CON TOMCAT
Accedemos al VM app01 con Tomcat.
`vagrant ssh app01`

Verificamos conexion del VM con los demas.
`cat /etc/hosts`

Actualizamos Paquetes necesarios.
`yum update -y`

Instalamos recursos necesarios.
`yum install epel-release -y`

Instalamos las dependencias.
`dnf -y install java-11-openjdk java-11-openjdk-devel`
`dnf install git maven wget -y`

Cambiamos la direccion a /tmp.
`cd /tmp/`

Descargamos Tomcat
`wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz`
`tar xzvf apache-tomcat-9.0.75.tar.gz`

Creamos el usuario Tomcat.
`useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat`

Copiamos los datos a Tomcat home-dir.
`cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/`
`chown -R tomcat.tomcat /usr/local/tomcat`

Setup systemctl command for tomcat
Creamos el fichero necesario del Servicio Tomcat.
`vi /etc/systemd/system/tomcat.service`

Actualizamos el contenido del fichero con:
                [Unit]
                Description=Tomcat
                After=network.target
                [Service]
                User=tomcat
                WorkingDirectory=/usr/local/tomcat
                Environment=JRE_HOME=/usr/lib/jvm/jre
                Environment=JAVA_HOME=/usr/lib/jvm/jre
                Environment=CATALINA_HOME=/usr/local/tomcat
                Environment=CATALINE_BASE=/usr/local/tomcat
                ExecStart=/usr/local/tomcat/bin/catalina.sh run
                ExecStop=/usr/local/tomcat/bin/shutdown.sh
                SyslogIdentifier=tomcat-%i
                [Install]
                WantedBy=multi-user.target

Recargamos los archivos de systemd.
`systemctl daemon-reload`

Iniciamos el servicio.
`systemctl start tomcat`
`systemctl enable tomcat`

Iniciamos el FIREWALL y el permiso de acceso a Tomcat al PUERTO 8080.
`systemctl start firewalld`
`systemctl enable firewalld`
`firewall-cmd --get-active-zones`
`firewall-cmd --zone=public --add-port=8080/tcp --permanent`
`firewall-cmd --reload`

Creamos el Codigo y desplegamos (app01)
Descargamos el codigo fuente:
`git clone -b main https://github.com/Samurai829/webapp-project.git`

Actualizamos la configuracion.
`cd webapp-project`
`vim src/main/resources/application.properties`

Corremos el comando dentro del directorio del repositorio.
`mvn install`

`systemctl stop tomcat`
`rm -rf /usr/local/tomcat/webapps/ROOT*`
`cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war`
`systemctl start tomcat`
`chown tomcat.tomcat /usr/local/tomcat/webapps -R`
`systemctl restart tomcat`


## CONFIGURACION DE WEB01 CON NGINX
Accedemos al VM web01.
`vagrant ssh web01`
`sudo -i`

Verificacion de conexion entre los demas VM.
`cat /etc/hosts`

Actualizamos los paquetes necesarios.
`apt update`
`apt upgrade`

Instalamos Nginx.
`apt install nginx -y`
Creamos el fichero de configuracion de Nginx.
`vi /etc/nginx/sites-available/vproapp`

Actualizamos el contenido del fichero:
                upstream vproapp {
                server app01:8080;
                }
                server {
                listen 80;
                location / {
                proxy_pass http://vproapp
                }
                }

Remueve el fichero de configuracion por defecto de Nginx:
`rm -rf /etc/nginx/sites-enabled/default`

Creamos la activacion.
`ln -s /etc/nginx/sites-available/webapp /etc/nginx/sites-enabled/vproapp`

Reiniciamos Nginx
`systemctl restart nginx`