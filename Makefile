
default: scripts

.PHONY: scripts
scripts:
	@echo "Creating directories..."
	mkdir -pv shared/standalone/scripts
# mkdir -pv shared/standalone/themes
# mkdir -pv shared/standalone/images

	@echo "Copying scripts..."
	cp -fpv scripts/apply-site-settings.rb shared/standalone/scripts/
# cp -fpv scripts/apply-themes.sh shared/standalone/scripts/
# cp -fpv images/* shared/standalone/images
