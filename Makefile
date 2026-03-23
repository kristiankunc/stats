build:
	@odin build stats

proper:
	@odin build stats -o:size

.PHONY: clean
clean:
	rm stats.bin
