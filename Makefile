# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: szapata42 <szapata42@student.42.fr>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/03 13:41:31 by szapata42         #+#    #+#              #
#    Updated: 2025/09/27 15:19:21 by szapata42        ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception

all: $(NAME)

$(NAME):
	@printf "Starting ${NAME} configuration\n"
	@printf "Creating data directories..\n"
	@mkdir -p ~/data/mariadb && mkdir -p ~/data/wordpress
	@docker compose -f srcs/docker-compose.yml build --no-cache
	@docker-compose -f srcs/docker-compose.yml up -d

down:
	@printf "Stopping ${NAME}\n"
	@docker-compose -f srcs/docker-compose.yml down

clean: down
	@printf "Cleaning up\n"
	@docker system prune -af

fclean: clean
	@printf "Complete cleanup coming up\n"
	@if [ -n "$$(docker ps -q)" ]; then \
		docker stop $$(docker ps -q); fi\
	@docker system prune --all --force --volumes 
	@docker network prune --force
	@docker volume prune --force
	@rm -rf ~/data

re: clean all

.PHONY: all clean fclean re down