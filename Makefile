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
all-tests: all-static all-canister-deploy-local-pytest 
	
.PHONY: all-canister-deploy-local-pytest
all-canister-deploy-local-pytest:
	dfx identity use default
	@python -m scripts.all_canister_deploy_local_pytest


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

# Note for clang++
# This command does not contain latest LLVM version that ships with wasi-sdk
# sudo apt-get update && sudo apt-get install clang-$(VERSION_CLANG)

.PHONY: install-clang-ubuntu
install-clang-ubuntu:
	@echo "Installing clang-$(VERSION_CLANG) compiler"
	sudo apt-get remove python3-lldb-14
	wget https://apt.llvm.org/llvm.sh
	chmod +x llvm.sh
	echo | sudo ./llvm.sh $(VERSION_CLANG)
	rm llvm.sh

	@echo "Creating soft links for compiler executables"
	sudo ln --force -s /usr/bin/clang-$(VERSION_CLANG) /usr/bin/clang
	sudo ln --force -s /usr/bin/clang++-$(VERSION_CLANG) /usr/bin/clang++


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
	cd icpp-candid && rm -rf src/*.egg-info && pip install -e ".[dev]"
	rm -rf src/*.egg-info
	pip install -e ".[dev]"

.PHONY: install-python-w-demos
install-python-w-demos:
	pip install --upgrade pip
	cd icpp-candid && rm -rf src/*.egg-info && pip install -e ".[dev]"
	rm -rf src/*.egg-info
	pip install -e ".[dev]"
	cd ../icpp-demos && pip install -r requirements.txt


.PHONY: install-python-w-icpp-llm
install-python-w-icpp-llm:
	pip install --upgrade pip
	cd icpp-candid && rm -rf src/*.egg-info && pip install -e ".[dev]"
	rm -rf src/*.egg-info
	pip install -e ".[dev]"
	cd ../icpp-llm && pip install -r requirements.txt

.PHONY:install-rust
install-rust:
	@echo "Installing rust"
	curl https://sh.rustup.rs -sSf | sh -s -- -y
	@echo "Installing ic-cdk-optimizer"
	cargo install ic-cdk-optimizer

.PHONY: install-wabt
install-wabt:
	sudo apt-get update && sudo apt-get install wabt

###########################################################################
# Building and publishing the pypi package
.PHONY: pypi-build
pypi-build:
	rm -rf dist
	python -m build

.PHONY: testpypi-upload
testpypi-upload:
	twine upload --config-file .pypirc -r testpypi dist/*

.PHONY: testpypi-install
testpypi-install:
	pip install -i https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ icpp

.PHONY: pypi-upload
pypi-upload:
	twine upload --config-file .pypirc dist/*

.PHONY: pypi-install
pypi-install:
	pip install icpp
