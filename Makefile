.PHONY: minecraftup minecraftdown \
        minecraftps minecraftlogs \
        monitorup monitordown \
        monitorps monitorlogs \
				allup alldown

SERVICES ?=

comma := ,
SERVICE_LIST = $(subst $(comma), ,$(SERVICES))

initnet:
	./scripts/init-network.sh

# All Stacks
allup:
	@echo "==> Starting Minecraft Stack..."
	@docker compose \
		-f minecraft-stack/docker-compose.yml \
		up -d $(SERVICE_LIST) || { \
			echo "ERROR: Failed to start Minecraft Stack."; \
			exit 1; \
		}
	@echo "==> Minecraft Stack started successfully."
	@echo
	@echo "==> Starting Monitor Stack..."
	@docker compose \
		-f monitor-stack/docker-compose.yml \
		up -d $(SERVICE_LIST) || { \
			echo "ERROR: Failed to start Monitor Stack."; \
			exit 1; \
		}
	@echo "==> Monitor Stack started successfully."
	@echo
	@echo "==> All stacks started successfully."

alldown:
	@echo "==> Stopping Monitor Stack..."
	@docker compose \
		-f monitor-stack/docker-compose.yml \
		down --remove-orphans || { \
			echo "ERROR: Failed to stop Monitor Stack."; \
			exit 1; \
		}
	@echo "==> Monitor Stack stopped successfully."
	@echo
	@echo "==> Stopping Minecraft Stack..."
	@docker compose \
		-f minecraft-stack/docker-compose.yml \
		down --remove-orphans || { \
			echo "ERROR: Failed to stop Minecraft Stack."; \
			exit 1; \
		}
	@echo "==> Minecraft Stack stopped successfully."
	@echo
	@echo "==> All stacks stopped successfully."

# Minecraft Stack
minecraftup:
	docker compose \
		-f minecraft-stack/docker-compose.yml \
		up -d $(SERVICE_LIST)

minecraftdown:
	docker compose \
		-f minecraft-stack/docker-compose.yml \
		down --remove-orphans

minecraftrestart:
	docker compose \
		-f minecraft-stack/docker-compose.yml \
		restart $(SERVICE_LIST)

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

monitorrestart:
	docker compose \
		-f monitor-stack/docker-compose.yml \
		restart $(SERVICE_LIST)

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
