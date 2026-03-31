build:
	@odin build stats
	@echo "compiled successfully!"

proper:
	@odin build stats -o:size -ignore-warnings
	@echo "compiled successfully!"

.PHONY: clean
clean:
	rm stats.bin
