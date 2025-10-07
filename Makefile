# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: szapata42 <szapata42@student.42.fr>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/03 13:41:31 by szapata42         #+#    #+#              #
#    Updated: 2025/10/01 15:52:17 by szapata42        ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
COMPOSE_FILE = srcs/docker-compose.yml
BONUS_COMPOSE = srcs/docker-compose.bonus.yml

all: $(NAME)

$(NAME):
	@printf "Starting ${NAME} configuration\n"
	@printf "Creating data directories..\n"
	@mkdir -p ~/data/mariadb && mkdir -p ~/data/wordpress
	@docker compose -f ${COMPOSE_FILE} build
	@docker-compose -f ${COMPOSE_FILE} up -d

bonus:
	@printf "Starting ${NAME} bonus configuration\n"
	@printf "Creating data directories..\n"
	@mkdir -p ~/data/mariadb && mkdir -p ~/data/wordpress
	@docker compose -f ${COMPOSE_FILE} -f ${BONUS_COMPOSE} build
	@docker compose -f ${COMPOSE_FILE} -f ${BONUS_COMPOSE} up -d

down:
	@printf "Stopping ${NAME}\n"
	@docker-compose -f ${COMPOSE_FILE} down

b_down:
	@printf "Stopping ${NAME} bonus\n"
	@docker-compose -f ${COMPOSE_FILE} -f ${BONUS_COMPOSE} down

clean: down
	@printf "Cleaning up\n"
	@docker system prune -af

fclean: clean
	@printf "Complete cleanup coming up\n"
	@if [ -n "$$(docker ps -q)" ]; then \
		docker stop $$(docker ps -q); fi
	@docker system prune --all --force --volumes 
	@docker network prune --force
	@docker volume prune --force
	@rm -rf ~/data

re: clean all

.PHONY: all clean fclean re down bonus b_down
