DEVELOPMENT_PATH = docker-compose.yml

## Misc
list: # List all available targets for this Makefile
	@grep '^[^#[:space:]].*:' Makefile

## Development
stop: # Stop all containers
	docker compose -f $(DEVELOPMENT_PATH) down

purge: # Stop and remove all containers, volumes and images
	docker compose -f $(DEVELOPMENT_PATH) down --rmi all --volumes --remove-orphans

build: stop # Build the containers
	docker compose -f $(DEVELOPMENT_PATH) build --no-cache
	docker compose -f $(DEVELOPMENT_PATH) run --rm app bin/setup

bash: # Open a bash session in the app container
	docker compose -f $(DEVELOPMENT_PATH) run --rm app bash

attach: # Attach to a running container and opens bash
	docker compose -f $(DEVELOPMENT_PATH) exec app bash

test: # Run rspec tests
	RAILS_ENV=test docker compose -f $(DEVELOPMENT_PATH) run --rm app bundle exec rspec

server: stop # Start the server
	docker compose -f $(DEVELOPMENT_PATH) up
