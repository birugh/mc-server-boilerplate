.PHONY: minecraftup minecraftdown \
        minecraftps minecraftlogs \
        monitorup monitordown \
        monitorps monitorlogs

SERVICES ?=

comma := ,
SERVICE_LIST = $(subst $(comma), ,$(SERVICES))

initnet:
	./scripts/init-network.sh

# Minecraft Stack
minecraftup:
	docker compose \
		-f minecraft-stack/docker-compose.yml \
		up -d $(SERVICE_LIST)

minecraftdown:
	docker compose \
		-f minecraft-stack/docker-compose.yml \
		down --remove-orphans

minecraftps:
	watch -n 1 -d \
		docker compose \
			-f minecraft-stack/docker-compose.yml \
			ps $(SERVICE_LIST)

minecraftlogs:
	@if [ -z "$(SERVICES)" ]; then \
		echo "Error: SERVICES is required."; \
		echo "Usage: make minecraftlogs SERVICES=<service>"; \
		exit 1; \
	elif [ "$(words $(subst ,, ,$(SERVICES)))" -ne 1 ]; then \
		echo "Error: only one service can be specified for minecraftlogs."; \
		echo "Usage: make minecraftlogs SERVICES=<service>"; \
		exit 1; \
	fi
	docker compose \
		-f minecraft-stack/docker-compose.yml \
		logs -f $(SERVICE_LIST)

# Monitoring Stack
monitorup:
	docker compose \
		-f monitor-stack/docker-compose.yml \
		up -d $(SERVICE_LIST)

monitordown:
	docker compose \
		-f monitor-stack/docker-compose.yml \
		down --remove-orphans

monitorps:
	watch -n 1 -d \
		docker compose \
			-f monitor-stack/docker-compose.yml \
			ps $(SERVICE_LIST)

monitorlogs:
	@if [ -z "$(SERVICES)" ]; then \
		echo "Error: SERVICES is required."; \
		echo "Usage: make monitorlogs SERVICES=<service>"; \
		exit 1; \
	elif [ "$(words $(subst ,, ,$(SERVICES)))" -ne 1 ]; then \
		echo "Error: only one service can be specified for monitorlogs."; \
		echo "Usage: make monitorlogs SERVICES=<service>"; \
		exit 1; \
	fi
	docker compose \
		-f monitor-stack/docker-compose.yml \
		logs -f $(SERVICE_LIST)