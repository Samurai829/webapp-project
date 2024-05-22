# PROYECTO WEB APP LOCAL MACHINE 🧑‍💻
Este es un proyecto donde uso Vagrant para aprovisionar varias VM con NGINX, Rabbitmq, Memcached, MySql y Tomcat para 
poder alojar una APP.

En este proyecto implemento 2 metodos para su realizacion, el primero es la configuracion y aprovisionamiento manual para 
cada una de las VM que alojan los servicios necesarios para una APP de Java y en la Segunda esta el proceso automatizado 
de configuracion del entorno VM creado como base del proyecto.

## PREPARACION DEL ENTORNO 💻
**PREREQUISITOS DE PROYECTO** 
Debemos tener instalador lo siguiente:

ORACLE VM VIRTUALBOX
VAGRANT
VAGRANT PLUGINS
    `vagrant.hostmanager`
    `vagrant.vbguest`
GIT BASH

## SERVICIOS DE ENTORNO ⚙️
Los servicios utilizados en estos proyectos son:
1. **NGINX** ===> Web Service
2. **TOMCAT** ===> Aplication Server
3. **RabbitMQ** ===> Broker Agent
4. **MemCache** ===> DB Cache
5. **ElasticSearch** ===> Indexing/Search Service
6. **MySQL** ===> SQL DataBase

