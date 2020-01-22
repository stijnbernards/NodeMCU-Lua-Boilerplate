PRJ_DIR := $(shell pwd)
PRJ_SRC_DIR := $(PRJ_DIR)/src
PRJ_MOCK_DIR := $(PRJ_DIR)/tests/mocks

LUA_PATH := "$(PRJ_SRC_DIR)/?.lua;$(PRJ_MOCK_DIR)/?.lua"

LUA_TEST_CASES := $(wildcard $(PRJ_DIR)/tests/*est*.lua)

.PHONY: help $(LUA_TEST_CASES)

help:
	@echo type: make clean
	@echo type: make test
	@echo type: make dist

$(LUA_TEST_CASES):
	@echo [INFO] : Running tests in $@ ...
	@export LUA_PATH=$(LUA_PATH) && lua $@

test: $(LUA_TEST_CASES)
