#------------------------------------------------------
# CONTRUCCION DE ENTORNO VAGRANT
#------------------------------------------------------

#------------------------------------------------------
# CONTRUCION Y DESPLIEGUE DE VARIAS VM
# CONFIGURACION Y INSTALACION RECURSOS NECESARIOS VM
#------------------------------------------------------

# VARIABLES
NAME = WEBAPP_VAGRANT
#------------------------------------------------------
help: ## GUIA DE USO
	@echo 'Inicializar Entorno usar init'
	@echo 'Visualizar Estatus de Entorno usar status'
	@echo 'Creacion de Entorno usar build'
	@echo 'Destruir Entorno usar destroy'

#------------------------------------------------------
init: ## INICIACION DE ENTORNO
	@echo 'Inicializar de entorno $(NAME)'
	vagrant init


#------------------------------------------------------
status: ## ESTATUS Y VERIFICACION DE ENTORNO
	@echo 'Estatus de entorno $(NAME)'
	vagrant global-status

#------------------------------------------------------
build: ## CREACION DE ENTORNO VAGRANT
	@echo 'Creacion de entorno $(NAME)'
	vagrant up
	vagrant status

#------------------------------------------------------
destroy: ## DESTRUCCION DE ENTORNO VAGRANT
	@echo 'Destruccion de Entorno $(NAME)'
	vagrant destroy
	@echo 'Verificacion de Estatus $(NAME)'
	vagrant status
