DIR=srcs/docker-compose.yml
DATA=/home/ewu/data

all: build up

# Build Docker images
build:
	@echo "Building Docker images..."
	mkdir -p $(DATA)/mariadb
	mkdir -p $(DATA)/wordpress
	cd $(DIR) && docker compose build

# Start containers
up:
	cd $(DIR) && docker compose up -d

# Stop and remove containers
down:
	@echo "Removing containers..."
	cd $(DIR) && docker compose down

# Start stopped containers (without rebuilding)
start:
	@echo "Starting containers..."
	cd $(DIR) && docker compose start

# Stop running containers (without removing them)
stop:
	cd $(DIR) && docker compose stop

# Clean everything (containers, volumes, network)
clean: down
	cd $(DIR) && docker compose down -v --rmi all
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
