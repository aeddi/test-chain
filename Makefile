MAKEFILE_DIR = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
NODES        = $(shell basename $(wildcard $(MAKEFILE_DIR)/nodes/node*))
NODES_DIR    = $(MAKEFILE_DIR)/nodes
GENESIS_FILE = $(MAKEFILE_DIR)/genesis.json
NODE_MODULES = $(MAKEFILE_DIR)/node_modules

help:
	@echo "Command      | Description                          "
	@echo "----------------------------------------------------"
	@echo "nodeX        | Run nodeX (X can be 1, 2, 3 or 4)    "
	@echo "concurrently | Run all nodes concurrently           "
	@echo "mprocs       | Run all nodes in separated panels    "
	@echo "clean        | Remove nodes states and node_modules "

$(NODES): force
	gnoland start --genesis $(GENESIS_FILE) --data-dir $(NODES_DIR)/$@/gnoland-data

force: ;

concurrently: $(NODE_MODULES)
	npm run concurrently

mprocs: $(NODE_MODULES)
	npm run mprocs

$(NODE_MODULES): $(MAKEFILE_DIR)/package.json
	cd $(MAKEFILE_DIR) && npm install

clean:
	@rm -rf $(NODE_MODULES)
	@for node in $(NODES); \
		do rm -rf $(NODES_DIR)/$$node/gnoland-data/{db,wal} ; \
		echo "{\n\t\"height\": \"0\",\n\t\"round\": \"0\",\n\t\"step\": 0\n}" > $(NODES_DIR)/$$node/gnoland-data/secrets/priv_validator_state.json; \
	done

.PHONY: help force concurrently mprocs clean $(NODES) $(NODE_MODULES)
