SHELL := /bin/bash

# Disable built-in rules and variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

NETWORK := local

###########################################################################
# OS we're running on
ifeq ($(OS),Windows_NT)
	detected_OS := Windows
else
	detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif

ifeq ($(detected_OS),Darwin)	  # Mac OS X  (Intel)
	OS += macos
	DIDC += didc-macos
endif
ifeq ($(detected_OS),Linux)		  # Ubuntu
	OS += linux
	DIDC += didc-linux64 
endif

ifeq ($(detected_OS),Windows_NT)  # Windows (icpp supports it but you cannot run this Makefile)
	OS += windows_cannot_run_make
endif
ifeq ($(detected_OS),Unknown)     # Unknown
	OS += unknown
endif

###########################################################################
# latest release of didc
VERSION_DIDC := $(shell curl --silent "https://api.github.com/repos/dfinity/candid/releases/latest" | grep -e '"tag_name"' | cut -c 16-25)

VERSION_BITCOIN := 25.0
VERSION_NVM := 0.39.7
VERSION_NODEJS := 20

.PHONY: summary
summary:
	@echo "-------------------------------------------------------------"
	@echo OS=$(OS)
	@echo VERSION_DIDC=$(VERSION_DIDC)
	@echo "-------------------------------------------------------------"

###########################################################################
# CI/CD - Phony Makefile targets
#
.PHONY: all-tests
all-tests: all-static all-deploy-and-pytest 
	
.PHONY: all-deploy-and-pytest
all-deploy-and-pytest:
	bitcoin-$(VERSION_BITCOIN)/bin/bitcoind \
		-conf=$(CURDIR)/bitcoin-$(VERSION_BITCOIN)/bitcoin.conf \
		-datadir=$(CURDIR)/bitcoin-$(VERSION_BITCOIN)/data \
		--port=18444 > /dev/null 2>&1 &

	@echo "Waiting for bitcoind to start..."
	@MAX_ATTEMPTS=30; \
	ATTEMPT=0; \
	while ! bitcoin-$(VERSION_BITCOIN)/bin/bitcoin-cli -conf=$(CURDIR)/bitcoin-$(VERSION_BITCOIN)/bitcoin.conf -datadir=$(CURDIR)/bitcoin-$(VERSION_BITCOIN)/data getblockchaininfo > /dev/null 2>&1; do \
		ATTEMPT=$$(($$ATTEMPT + 1)); \
		if [ $$ATTEMPT -ge $$MAX_ATTEMPTS ]; then \
			echo "bitcoind did not start within the expected time frame."; \
			exit 1; \
		fi; \
		echo "Waiting for bitcoind to be ready..."; \
		sleep 1; \
	done; \
	echo "bitcoind is up and running."
	
	dfx identity use default
	dfx stop
	dfx start --clean --background

	cd backend/donation_canister && \
		dfx deploy donation_canister --argument '(variant { regtest })' && \
		donation_canister_id=$$(dfx canister id donation_canister) && \
		echo "donation_canister_id: $${donation_canister_id}" && \
		argument_string=$$'("'$${donation_canister_id}'")' && \
		echo "argument_string: $${argument_string}" && \
		cd ../donation_tracker_canister && \
			dfx deploy donation_tracker_canister --argument $${argument_string} && \
			dfx canister call donation_tracker_canister initRecipients

	pytest

	dfx stop

	bitcoin-$(VERSION_BITCOIN)/bin/bitcoin-cli \
		-conf=$(CURDIR)/bitcoin-$(VERSION_BITCOIN)/bitcoin.conf \
		-datadir=$(CURDIR)/bitcoin-$(VERSION_BITCOIN)/data \
		stop

.PHONY: bitcoin-core-start
bitcoin-core-start: 
	bitcoin-$(VERSION_BITCOIN)/bin/bitcoind \
		-conf=$(CURDIR)/bitcoin-$(VERSION_BITCOIN)/bitcoin.conf \
		-datadir=$(CURDIR)/bitcoin-$(VERSION_BITCOIN)/data \
		--port=18444

.PHONY: bitcoin-core-stop
bitcoin-core-stop: 
	bitcoin-$(VERSION_BITCOIN)/bin/bitcoin-cli \
		-conf=$(CURDIR)/bitcoin-$(VERSION_BITCOIN)/bitcoin.conf \
		-datadir=$(CURDIR)/bitcoin-$(VERSION_BITCOIN)/data \
		stop

.PHONY: all-static
all-static: \
	python-format python-lint python-type
	
PYTHON_DIRS ?= backend/donation_tracker_canister/test

.PHONY: python-format
python-format:
	@echo "---"
	@echo "python-format"
	python -m black $(PYTHON_DIRS)

.PHONY: python-lint
python-lint:
	@echo "---"
	@echo "python-lint"
	python -m pylint --jobs=0 --rcfile=.pylintrc $(PYTHON_DIRS)

.PHONY: python-type
python-type:
	@echo "---"
	@echo "python-type"
	python -m mypy --config-file .mypy.ini --show-column-numbers --strict $(PYTHON_DIRS)


###########################################################################
# Toolchain installation for .github/workflows

# https://internetcomputer.org/docs/current/tutorials/developer-journey/level-4/4.3-ckbtc-and-bitcoin/#setting-up-a-local-bitcoin-network
.PHONY: install-bitcoin-core
install-bitcoin-core:
	mkdir -p ~/.config/dfx
	cp cicd-helpers/networks.json ~/.config/dfx/
	cat ~/.config/dfx/networks.json
	wget https://bitcoin.org/bin/bitcoin-core-$(VERSION_BITCOIN)/bitcoin-$(VERSION_BITCOIN)-x86_64-linux-gnu.tar.gz -O bitcoin.tar.gz
	rm -rf bitcoin-$(VERSION_BITCOIN)
	tar -xzf bitcoin.tar.gz
	cd bitcoin-$(VERSION_BITCOIN) && \
		mkdir data && \
		cp bitcoin.conf x && \
		cp ../cicd-helpers/bitcoin.conf . && \
		cat x >> bitcoin.conf

# This installs ~/bin/dfx
# Make sure to source ~/.profile afterwards -> it adds ~/bin to the path if it exists
.PHONY: install-dfx
install-dfx:
	sh -ci "$$(curl -fsSL https://sdk.dfinity.org/install.sh)"

.PHONY: install-didc
install-didc:
	@echo "Installing didc $(VERSION_DIDC) ..."
	sudo rm -rf /usr/local/bin/didc
	wget https://github.com/dfinity/candid/releases/download/${VERSION_DIDC}/$(DIDC)
	sudo mv $(DIDC) /usr/local/bin/didc
	chmod +x /usr/local/bin/didc
	@echo " "
	@echo "Installed successfully in:"
	@echo /usr/local/bin/didc

.PHONY: install-jp
install-jp:
	sudo apt-get update && sudo apt-get install jp

.PHONY: install-python
install-python:
	pip install --upgrade pip
	pip install -r requirements.txt

.PHONY: install-nvm
install-nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$(VERSION_NVM)/install.sh | bash

.PHONY: install-nodejs
install-nodejs:
	nvm use $(VERSION_NODEJS)

.PHONY: install-mops
install-mops:
	npm i -g ic-mops
	cd backend/donation_tracker_canister && \
		mops install