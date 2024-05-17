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

## CONFIGURACION DE DB01 
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

 `git clone -b main