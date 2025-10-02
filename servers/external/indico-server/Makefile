


all: up

up:
	docker compose --env-file config.env up -d --build

up_debug:
	docker compose --env-file config.env up


down:
	docker compose --env-file config.env down

prune:
	docker system prune -a
