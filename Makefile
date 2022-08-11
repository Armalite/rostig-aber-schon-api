SHELL=/bin/bash -e -o pipefail
bold := $(shell tput bold)
sgr0 := $(shell tput sgr0)

.PHONY: help install check
.SILENT:

output_location = "output"

MAKEFLAGS += --warn-undefined-variables
.DEFAULT_GOAL := help

## display help message
help:
	@awk '/^##.*$$/,/^[~\/\.0-9a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

update:
	sudo apt update

install-rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install progress. After install, go to server with `sudo -u postgres psql` then type \password to your desired password
# You can check status of the postgres server with `service postgresql status`
install-postgres:
	apt install postgresql

install-nightly:
	rustup default nightly

install-diesel:
	cargo install diesel_cli --no-default-features --features postgres

# Creates a database on post gres
setup-diesel: install-diesel
	export DATABASE_URL=postgres://postgres:postgres@localhost:5432/diesel_demo > .env; \
	diesel setup; \
	diesel migration generate users;

install: install-rust, install-nightly, install-diesel
	;



