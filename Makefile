DIR="./srcs/docker-compose.yml"

all:
	@mkdir -p $(HOME)/data/wordpress
	@mkdir -p $(HOME)/data/mariadb
	@docker compose -f $(DIR) up
# up:
# 	@docker compose -f $(DIR) up --build -d

down:
	@docker compose -f $(DIR) down

re:
	@docker compose -f $(DIR) up --build

clean:
	@docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q);\
	docker network rm $$(docker network ls -q);\
	rm -rf $(HOME)/data/wordpress
	rm -rf $(HOME)/data/mariadb

.PHONY: all re down clean