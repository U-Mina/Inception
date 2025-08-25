DIR=srcs/docker-compose.yml
DATA=/home/ewu/data
COMPOSE = docker-compose

all: build up

# Build Docker images
build:
	@echo "Building Docker images..."
	mkdir -p $(DATA)/mariadb
	mkdir -p $(DATA)/wordpress
	docker-compose -f $(DIR) build

# Start containers
up:
	docker-compose -f $(DIR) up -d

# Stop and remove containers
down:
	@echo "Removing containers..."
	docker-compose -f $(DIR) down

# Start stopped containers (without rebuilding)
start:
	@echo "Starting containers..."
	docker-compose -f $(DIR) start

# Stop running containers (without removing them)
stop:
	docker-compose -f $(DIR) stop

# Clean everything (containers, volumes, network)
clean: down
	docker-compose -f $(DIR) down -v --rmi all
	sudo rm -rf $(DATA)/mariadb
	sudo rm -rf $(DATA)/wordpress

# Full clean: remove everything (containers, images, volumes, networks)
fclean: clean
	docker system prune -a -f
	docker network prune -f

# Rebuild and restart containers
re: clean build up

.PHONY: all build up down start stop clean fclean re


# all:
# 	@mkdir -p $(HOME)/data/wordpress
# 	@mkdir -p $(HOME)/data/mariadb
# 	@docker compose -f ./srcs/docker-compose.yml up

# down:
# 	@docker compose -f ./srcs/docker-compose.yml down

# re:
# 	@docker compose -f ./srcs/docker-compose.yml up --build

# clean:
# 	@docker stop $$(docker ps -qa);\
# 	docker rm $$(docker ps -qa);\
# 	docker rmi -f $$(docker images -qa);\
# 	docker volume rm $$(docker volume ls -q);\
# 	docker network rm $$(docker network ls -q);\
# 	rm -rf $(HOME)/data/wordpress
# 	rm -rf $(HOME)/data/mariadb

# .PHONY: all re down clean
