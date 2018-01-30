.PHONY: install

install:
	mkdir -p ${out}
	mv build/* ${out}/
	rm -rf ${out}/nix-support
