# Define directory and file constants
MODRINTH_DIR := modrinth           # Directory for Modrinth modpack files

# Define color codes for console output
RED := \033[0;31m          # Red color for error messages
GREEN := \033[0;32m        # Green color for success messages
YELLOW := \033[1;33m       # Yellow color for info/warning messages
NC := \033[0m              # No color (reset)

# Set default target to show help message
.DEFAULT_GOAL := help

# Show available commands
help:
	@echo "Available commands:"
	@echo "  make update    - Update the modpack (Modrinth)"

# Update Modrinth modpack (update all mods + export pack)
update:
	@echo -e "$(YELLOW) Updating Modrinth modpack...$(NC)"
	@if [ -d $(MODRINTH_DIR) ]; then \
		cd $(MODRINTH_DIR) && \
		echo -e "$(YELLOW) Running packwiz update --all (Modrinth)...$(NC)" && \
		packwiz update --all && \
		echo -e "$(YELLOW) Running packwiz mr export (Modrinth)...$(NC)" && \
		packwiz mr export; \
		if [ $$? -ne 0 ]; then \
			echo -e "$(RED) Modrinth update FAILED! $(NC)"; \
			exit 1; \
		fi; \
	else \
		echo -e "$(RED) Directory $(MODRINTH_DIR) not found! $(NC)"; \
		exit 1; \
	fi

# Declare phony targets (non-file targets)
.PHONY: help update