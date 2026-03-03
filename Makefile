SHELL = /bin/bash

include aidc/.env

###############################
# Downloads
###############################

DSE_TGZ_URL = $(DOWNLOAD_PATH)/$(DSE_TGZ_FILE)
DFE_WAF_URL = $(DOWNLOAD_PATH)/$(DFE_WAF_FILE)
DFE_RPM_URL = $(DOWNLOAD_PATH)/$(DFE_RPM_FILE)
DFE_DEB_URL = $(DOWNLOAD_PATH)/$(DFE_DEB_FILE)
DFE_UBN_URL = $(DOWNLOAD_PATH)/$(DFE_UBN_FILE)
DEMO_TGZ_URL = $(DOWNLOAD_PATH)/$(DEMO_TGZ_FILE)

WHL_PATH = https://localhost:$(WEBUI)/assets/automation/client-lib
DSE_MODELS_FILE = keysight_dse_models-$(DSE_MODELS_VERSION)-py3-none-any.whl
DSE_CLIENT_FILE = keysight_dse_client-$(DSE_CLIENT_VERSION)-py3-none-any.whl
CHAKRA_FILE 	= keysight_chakra-$(CHAKRA_VERSION)-py3-none-any.whl

DSE_MODELS_URL = $(WHL_PATH)/$(DSE_MODELS_FILE)
DSE_CLIENT_URL = $(WHL_PATH)/$(DSE_CLIENT_FILE)
CHAKRA_URL     = $(WHL_PATH)/$(CHAKRA_FILE)


###############################
# Downloads
###############################


.PHONY: url
url:
	@echo "DSE TGZ Package   :  $(DSE_TGZ_URL)"
	@echo "DFE WAF Package   :  $(DFE_WAF_URL)"
	@echo "DFE RPM Package   :  $(DFE_RPM_URL)"
	@echo "DFE Debian Package:  $(DFE_DEB_URL)"
	@echo "DFE Ubuntu Package:  $(DFE_UBN_URL)"
#	@echo "Demo TGZ Archive: $(DEMO_TGZ_URL)"
	@echo "DSE Models Module: $(DSE_MODELS_URL)"
	@echo "DSE Client Module: $(DSE_CLIENT_URL)"
	@echo "Chakra Module:     $(CHAKRA_URL)"

.PHONY: pull
pull: pull-echo pull-dse-tgz-n pull-dfe-waf-n pull-dfe-rpm-n pull-dfe-deb-n pull-dfe-ubn-n #pull-demo-tgz-n

pull-echo:
	@echo "Downloading into $(CURDIR)/downloads:"

pull-dse-tgz: pull-echo pull-dse-tgz-n
pull-dse-tgz-n:
	@mkdir -p downloads && cd downloads \
	&& echo -n "  - DSE TGZ $(DSE_TGZ_FILE) ... " \
	&& curl -kfsSL -O $(DSE_TGZ_FILE) \
	&& echo "complete."

pull-dfe-waf: pull-echo pull-dfe-waf-n
pull-dfe-waf-n:
	@mkdir -p downloads && cd downloads \
	&& echo -n "  - DFE WAF $(DFE_WAF_FILE) ... " \
	&& curl -kfsSL -O $(DFE_WAF_URL) \
	&& echo "complete."

pull-dfe-rpm: pull-echo pull-dfe-rpm-n
pull-dfe-rpm-n:
	@mkdir -p downloads && cd downloads \
	&& echo -n "  - DFE RPM $(DFE_RPM_FILE) ... " \
	&& curl -kfsSL -O $(DFE_RPM_URL) \
	&& echo "complete."

pull-dfe-deb: pull-echo pull-dfe-deb-n
pull-dfe-deb-n:
	@mkdir -p downloads/debian && cd downloads/debian \
	&& echo -n "  - DFE Debian $(DFE_DEB_FILE) ... " \
	&& curl -kfsSL -O $(DFE_DEB_URL) \
	&& echo "complete."

pull-dfe-ubn: pull-echo pull-dfe-ubn-n
pull-dfe-ubn-n:
	@mkdir -p downloads/ubuntu && cd downloads/ubuntu \
	&& echo -n "  - DFE Ubuntu $(DFE_UBN_FILE) ... " \
	&& curl -kfsSL -O $(DFE_UBN_URL) \
	&& echo "complete."

#pull-demo-tgz: pull-echo pull-demo-tgz-n
#pull-demo-tgz-n:
#	@mkdir -p downloads && cd downloads \
#	&& echo -n "  - Demo TGZ $(DEMO_TGZ_FILE) ... " \
#	&& curl -kfsSL -O $(DEMO_TGZ_URL) \
#	&& echo "complete."

pull: pull-modules
pull-modules:
	@echo "Downloading modules for automation into $(STORAGE)/notebooks/modules ..."
	@./bin/pull-modules.sh https://localhost:$(WEBUI) $(STORAGE)/notebooks/modules

###############################
# Installation
###############################

.PHONY: install-dse-tgz install-dfe-rpm install-dfe-deb install-dfe-ubn

install-dse-tgz:
	@echo "Importing DSE Docker image..."
	@docker load -i downloads/$(DSE_TGZ_FILE)
	@echo "DSE TGZ package installed successfully."

install-dfe-rpm:
	@echo "Installing DFE RPM package..."
	@dnf install -y downloads/$(DFE_RPM_FILE)
	@echo "DFE RPM package installed successfully."

install-dfe-deb:
	@echo "Installing DFE Debian package..."
	@dpkg -i downloads/debian/$(DFE_DEB_FILE)
	@echo "DFE Debian package installed successfully."

install-dfe-ubn:
	@echo "Installing DFE Ubuntu package..."
	@dpkg -i downloads/ubuntu/$(DFE_DEB_FILE)
	@echo "DFE Ubuntu package installed successfully."

###############################
# Jupyter Notebooks
###############################

notebooks: copy-requirements mkdir-venv copy-notebooks

copy-requirements:
	@echo "Copying requirements.txt to $(STORAGE)/notebooks/modules ..."
	mkdir -p $(STORAGE)/notebooks/modules
	sudo cp -f notebooks/requirements.txt $(STORAGE)/notebooks
	sudo chgrp -R 100 $(STORAGE)/notebooks
	@echo "Copy complete."

mkdir-venv:
	@echo "Creating $(HOME)/.venv/dse ..."
	mkdir -p $(HOME)/.venv/dse
	sudo chgrp -R 100 $(HOME)/.venv/dse
	sudo chmod -R g+w $(HOME)/.venv/dse
	@echo "Create complete."

copy-notebooks:
	@echo "Copying notebooks to $(STORAGE)/notebooks ..."
	mkdir -p $(STORAGE)/notebooks
	sudo cp -f notebooks/*.ipynb $(STORAGE)/notebooks
	sudo chgrp -R 100 $(STORAGE)/notebooks
	sudo chmod -R g+w $(STORAGE)/notebooks
	@echo "Copy complete."SHELL = /bin/bash

# Clean up

clean-venv:
	@echo "Cleaning $(HOME)/.venv/dse ..."
	rm -rf $(HOME)/.venv/dse
	@echo "Cleanup complete."
