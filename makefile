# Liste des cibles disponibles dans les sous-répertoires
GLOBAL_TARGETS := init
TARGETS := up stop down backup update 
# Liste de tous les répertoires
SUBDIRS := $(filter-out backup/. .git/.,$(wildcard */.))

global_init:
	if [ "$$(systemctl is-active docker)" != active ]; then sudo systemctl start docker.service; else echo "docker already running"; fi
	if [ "$$(docker network ls --filter "name=^traefik_network$$" --format '{{.Name}}')" != "traefik_network" ]; then docker network create traefik_network; else echo "traefik_network already exist"; fi

init: global_init $(SUBDIRS)


test:
	echo $(SUBDIRS)
	echo $@

# Chacune des cible redirige vers la même cible dans le makefile de chacun des sous-répertoires
$(TARGETS): $(SUBDIRS)
# Appel de la fonction make dans chaque sous-répertoire (-C dir) et transmission du goal
$(SUBDIRS):
	echo $@
	$(MAKE) -C $@ $(filter-out $(SUBDIRS),$(MAKECMDGOALS))

# Réalise la fonction même si les dépendances n'ont pas changées
.PHONY: $(TARGETS) $(SUBDIRS)

