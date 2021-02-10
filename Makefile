SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

## help                                 : provides help
help : Makefile
	@sed -n 's/^##//p' $<
.PHONY : help

## install                              : tmp/.sentinel.systemctl-daemon-reload
install: tmp/.sentinel.systemctl-daemon-reload
.PHONY: install

## clean                                : forces recursive removes folders tmp/
clean:
	rm -rf tmp
.PHONY: clean

## tmp/.sentinel.systemctl-daemon-reload: reload systemctl daemon
tmp/.sentinel.systemctl-daemon-reload: tmp/.sentinel.install-all
	@mkdir -p $(@D)
	systemctl daemon-reload
	touch $@

## tmp/.sentinel.install-all            : install all unit files
tmp/.sentinel.install-all: tmp/.sentinel.install-user tmp/.sentinel.install-system
	@mkdir -p $(@D)
	touch $@

## tmp/.sentinel.install-system         : install all system systemd unit files
tmp/.sentinel.install-system: $(shell find system -type f -path "./system/*")
	@mkdir -p $(@D)
	install -m 0755 -C -v system/* /etc/systemd/system/
	touch $@

## tmp/.sentinel.install-user           : install all user systemd unit files
tmp/.sentinel.install-user: $(shell find user -type f -path "./user/*")
	@mkdir -p $(@D)
	install -m 0755 -C -v user/* /etc/systemd/user/
	touch $@
