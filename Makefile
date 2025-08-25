DATA=/home/ewu/data

# adapt to docker compose versions 
COMPOSE = $(shell \
    if docker compose version >/dev/null 2>&1; then \
        echo "docker compose"; \
    elif docker-compose version >/dev/null 2>&1; then \
        echo "docker-compose"; \
    else \
        echo "docker compose"; \
    fi)

# default
all: build

# Build Docker images
build:
	@echo "Building Docker images..."
	@cd srcs && $(COMPOSE) up --build -d

# up:
# 	docker compose -f $(DIR) up -d

# Stop and remove containers
down:
	@echo "Removing containers..."
	@cd srcs && $(COMPOSE) down

# Start stopped containers (without rebuilding)
# start:
# 	@echo "Starting containers..."
# 	docker compose -f $(DIR) start

# Stop running containers (without removing them)
stop:
	@cd srcs && $(COMPOSE) stop

# Clean everything (containers, volumes, network)
clean: down
	@cd srcs && $(COMPOSE) down -v --rmi all
	@sudo rm -rf $(DATA)/mariadb
	@sudo rm -rf $(DATA)/wordpress

# Full clean: remove everything (containers, images, volumes, networks)
fclean: clean
	@docker system prune -a -f
	@docker network prune -f

# Rebuild and restart containers
re: clean build

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
