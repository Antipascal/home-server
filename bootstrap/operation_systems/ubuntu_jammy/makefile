include .env

install: start compress_iso
	@echo "Ubuntu Jammy installed successfully to $(BUILD_DIR)"
start:
	@echo "Install Ubuntu Jammy"
	@echo "===================="
	@echo
	@echo "This script will install Ubuntu Jammy on your system."
	@echo "		Updating package lists..."
	@sudo apt-get update
	@echo "		Upgrading packages..."
	@sudo apt-get upgrade -y
	@echo "		Installing packages..."
	@sudo apt-get install -y \
		rsync \
		wget \
		genisoimage \
		isolinux \
		xorriso

mount_iso:
	@echo "Mounting iso"
	@cd ./scripts && ./iso_mount.sh
update_configs: mount_iso
	@echo "Add custom configs to build"
	@cd ./scripts && ./update_config.sh
compress_iso: update_configs
	@echo "Compress iso file"
	@cd ./scripts && ./iso_compress.sh