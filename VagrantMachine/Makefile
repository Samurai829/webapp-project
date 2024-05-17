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
	@echo 'Visualizar Estatus de Entorno usar status'
	@echo 'Creacion de Entorno usar build'
	@echo 'Inicializar Entorno usar init'
	@echo 'Destruir Entorno usar destroy'
#------------------------------------------------------
status: ## ESTATUS Y VERIFICACION DE ENTORNO
	@echo 'Estatus de entorno $(NAME)'
	vagrant global-status

#------------------------------------------------------
build: ## CREACION DE ENTORNO VAGRANT
	@echo 'Creacion de entorno $(NAME)'
	vagrant up

#------------------------------------------------------
init: ## INICIACION DE ENTORNO VAGRANT
	@echo 'Verificacion de Estatus $(NAME)'
	$(MAKE) status
	@echo 'Creacion de entorno $(NAME)'
	$(MAKE) build

#------------------------------------------------------
destroy: ## DESTRUCCION DE ENTORNO VAGRANT
	@echo 'Verificacion de Estatus $(NAME)'
	$(MAKE) status
	@echo 'Destruccion de Entorno $(NAME)'
	vagrant destroy
