# Define directory and file constants
CURSEFORGE_DIR := curseforge       # Directory for CurseForge modpack files
MODRINTH_DIR := modrinth           # Directory for Modrinth modpack files
SYNC_SCRIPT := sync_meta.sh        # Script for syncing metadata files

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
	@echo "  make update    - Update the modpack (CurseForge + Modrinth)"


# Main update target: sync metadata → update CurseForge → update Modrinth
update: sync_meta curseforge_update modrinth_update
	@echo -e "$(GREEN) DONE! $(NC)"

# Sync metadata using the specified script
sync_meta:
	@echo -e "$(YELLOW) Executing sync script: $(SYNC_SCRIPT)...$(NC)"
	@if [ -f $(SYNC_SCRIPT) ]; then \
		bash $(SYNC_SCRIPT); \
		if [ $$? -ne 0 ]; then \
			echo -e "$(RED) sync_meta FAILED! $(NC)"; \
			exit 1; \
		fi; \
	else \
		echo -e "$(RED) Script $(SYNC_SCRIPT) not found! $(NC)"; \
		exit 1; \
	fi

# Update CurseForge modpack (update all mods + export pack)
curseforge_update:
	@echo -e "$(YELLOW) Updating CurseForge modpack...$(NC)"
	@if [ -d $(CURSEFORGE_DIR) ]; then \
		cd $(CURSEFORGE_DIR) && \
		echo -e "$(YELLOW) Running packwiz update --all (CurseForge)...$(NC)" && \
		packwiz update --all && \
		echo -e "$(YELLOW) Running packwiz cf export (CurseForge)...$(NC)" && \
		packwiz cf export; \
		if [ $$? -ne 0 ]; then \
			echo -e "$(RED) CurseForge update FAILED! $(NC)"; \
			exit 1; \
		fi; \
	else \
		echo -e "$(RED) Directory $(CURSEFORGE_DIR) not found! $(NC)"; \
		exit 1; \
	fi

# Update Modrinth modpack (update all mods + export pack)
modrinth_update:
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
.PHONY: help update sync_meta curseforge_update modrinth_update