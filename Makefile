SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

## build                                : tmp/.install.sentinel
build: tmp/.install.sentinel tmp/.systemctl-daemon-reload.sentinel
.PHONY: build

## clean                                : forces recursive removes folders tmp/ and out/
clean:
	rm -rf tmp
.PHONY: clean

## tmp/.systemctl-daemon-reload.sentinel: reload systemctl daemon
tmp/.systemctl-daemon-reload.sentinel:
	@mkdir -p $(@D)
	systemctl daemon-reload
	touch $@

## tmp/.install.sentinel                : install all unit files into respective system and user destinations
tmp/.install.sentinel: tmp/.install-user.sentinel tmp/.install-system.sentinel
	@mkdir -p $(@D)
	touch $@

## tmp/.install-system.sentinel         : install all system systemd unit files
tmp/.install-system.sentinel: $(shell find system -type f)
	@mkdir -p $(@D)
	install -m 0755 -C -v system/* /etc/systemd/system/
	touch $@

## tmp/.install-user.sentinel           : install all user systemd unit files
tmp/.install-user.sentinel: $(shell find user -type f)
	@mkdir -p $(@D)
	install -m 0755 -C -v user/* /etc/systemd/user/
	touch $@

## help                                 : provides help
help : Makefile
	@sed -n 's/^##//p' $<
.PHONY : help
