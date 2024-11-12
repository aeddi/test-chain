MAKEFILE_DIR = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
NODES        = $(shell basename $(wildcard $(MAKEFILE_DIR)/node*))

$(NODES): force
	gnoland start --genesis ./genesis.json --data-dir "./$@/gnoland-data"

force: ;

clean:
	@for node in $(NODES); \
		do rm -rf $$node/gnoland-data/{db,wal}; \
		echo "{\n\t\"height\": \"0\",\n\t\"round\": \"0\",\n\t\"step\": 0\n}" > $$node/gnoland-data/secrets/priv_validator_state.json; \
	done
