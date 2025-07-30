SHELL = /bin/bash

include aidc/env.latest

###############################
# Downloads
###############################

DSE_TGZ_URL = $(DOWNLOAD_PATH)/$(DSE_TGZ_FILE)
DFE_WAF_URL = $(DOWNLOAD_PATH)/$(DFE_WAF_FILE)
DFE_RPM_URL = $(DOWNLOAD_PATH)/$(DFE_RPM_FILE)
DFE_DEB_URL = $(DOWNLOAD_PATH)/debian/$(DFE_DEB_FILE)
DFE_UBN_URL = $(DOWNLOAD_PATH)/ubuntu/$(DFE_DEB_FILE)
DEMO_TGZ_URL = $(DOWNLOAD_PATH)/$(DEMO_TGZ_FILE)

.PHONY: url
url:
	@echo "DSE TGZ Package   :  $(DSE_TGZ_URL)"
	@echo "DFE WAF Package   :  $(DFE_WAF_URL)"
	@echo "DFE RPM Package   :  $(DFE_RPM_URL)"
	@echo "DFE Debian Package:  $(DFE_DEB_URL)"
	@echo "DFE Ubuntu Package:  $(DFE_UBN_URL)"
#	@echo "Demo TGZ Archive: $(DEMO_TGZ_URL)"

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
	&& echo -n "  - DFE Ubuntu $(DFE_DEB_FILE) ... " \
	&& curl -kfsSL -O $(DFE_DEB_URL) \
	&& echo "complete."

#pull-demo-tgz: pull-echo pull-demo-tgz-n
#pull-demo-tgz-n:
#	@mkdir -p downloads && cd downloads \
#	&& echo -n "  - Demo TGZ $(DEMO_TGZ_FILE) ... " \
#	&& curl -kfsSL -O $(DEMO_TGZ_URL) \
#	&& echo "complete."

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
