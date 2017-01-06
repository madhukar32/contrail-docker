## Variables accepted
#
# KEEP_IMAGES - to avoid cleaning up container images locally
#
##

# If SKU is not defined, default to mitaka
ifndef CONTRAIL_SKU
	export CONTRAIL_SKU := mitaka
endif

ifndef CONTRAIL_REPO_PORT
	export CONTRAIL_REPO_PORT := 1567
endif

ifndef CONTRAIL_REPO_IP
	export CONTRAIL_REPO_IP := $(shell ifconfig docker0 | awk '/inet.addr:/ {print $$2}' | cut -f2 -d:)
endif

ifndef SSHUSER
	export SSHUSER := root
endif

ifdef docker_http_proxy
	export http_proxy_build_arg :=  --build-arg http_proxy=$(docker_http_proxy) --build-arg https_proxy=$(docker_http_proxy) --build-arg no_proxy=$(CONTRAIL_REPO_IP)
else
	export http_proxy_build_arg :=
endif

ifdef CONTRAIL_REPO_MIRROR_SNAPSHOT
    export repo_snapshot_build_arg := --build-arg CONTRAIL_REPO_MIRROR_SNAPSHOT=$(CONTRAIL_REPO_MIRROR_SNAPSHOT)
endif

# Define all containers to be built
ifndef CONTAINERS
CONTAINERS = controller analytics agent analyticsdb lb kube-manager mesos-manager
endif

# OS - operaing system release code
# ubuntu 14.04 - u14.04, ubuntu 16.04 - u16.04, centos 7.1 - c7.1
ifndef OS
$(warning OS is undefined, default to u14.04)
	export OS := u14.04
endif


# CONTRAIL_VERSION is requisite so fail, if not provided
ifndef CONTRAIL_VERSION
$(error CONTRAIL_VERSION is undefined)
endif

CONTAINER_TARS = $(CONTAINERS:%=contrail-%-$(OS)-$(CONTRAIL_VERSION).tar.gz)

CONTRAIL_INSTALL_PACKAGE_TAR = contrail-install-packages_$(CONTRAIL_VERSION)-$(CONTRAIL_SKU).tgz

CONTRAIL_REPO_CONTAINER = contrail-apt-repo
CONTRAIL_REPO_CONTAINER_TAR = $(CONTRAIL_REPO_CONTAINER)-$(CONTRAIL_VERSION).tar.gz

CONTRAIL_ANSIBLE_TAR = contrail-ansible-$(CONTRAIL_VERSION).tar.gz
CONTRAIL_ANSIBLE_REPO = "git@github.com:Juniper/contrail-ansible.git"
CONTRAIL_ANSIBLE_REF = "master"
CONTRAIL_ANSIBLE = contrail-ansible

# This is the default target which should build all containers
.PHONY: all

all: $(CONTAINER_TARS)

contrail-%: contrail-%-$(OS)-$(CONTRAIL_VERSION).tar.gz
	@touch $@

$(CONTAINER_TARS): prep
	$(eval CONTRAIL_BUILD_ARGS := --build-arg CONTRAIL_REPO_URL=http://$(CONTRAIL_REPO_IP):$(CONTRAIL_REPO_PORT) )
	$(eval CONTRAIL_BUILD_ARGS +=  --build-arg CONTRAIL_ANSIBLE_TAR=$(CONTRAIL_ANSIBLE_TAR) )
	$(eval CONTRAIL_BUILD_ARGS += $(http_proxy_build_arg))
	$(eval CONTRAIL_BUILD_ARGS += $(repo_snapshot_build_arg))
	$(eval TEMP := $(shell mktemp -d))
	$(eval CONTAINER := $(subst -$(CONTRAIL_VERSION).tar.gz,,$@))
	$(eval CONTAINER_NAME := $(subst contrail-,,$(subst -$(OS)-$(CONTRAIL_VERSION).tar.gz,,$@)))
	@echo "Building the container $(CONTAINER):$(CONTRAIL_VERSION)"
	cp -rf tools/python-contrailctl $(CONTRAIL_ANSIBLE_TAR) docker/*.sh docker/*.key docker/$(CONTAINER_NAME)/* $(TEMP)
	if [ -d $(TEMP)/$(OS) ]; then \
		cp -rf $(TEMP)/$(OS)/* $(TEMP)/; \
	fi
	cd $(TEMP); \
	docker build $(CONTRAIL_BUILD_ARGS) -t $(CONTAINER):$(CONTRAIL_VERSION) .
ifndef NO_CACHE
	docker save $(CONTAINER):$(CONTRAIL_VERSION) | gzip -c > $@
endif
	rm -fr $(TEMP)


prep: contrail-repo contrail-ansible
	@touch prep

contrail-ansible: $(CONTRAIL_ANSIBLE_TAR)
	@touch contrail-ansible


contrail-repo: $(CONTRAIL_REPO_CONTAINER_TAR)
	@touch contrail-repo

$(CONTRAIL_ANSIBLE_TAR):
ifdef $(CONTRAIL_ANSIBLE_ARTIFACT)
	if [[ -f $(CONTRAIL_ANSIBLE_ARTIFACT) ]]; then  \
		cp -f $(CONTRAIL_ANSIBLE_ARTIFACT) $(CONTRAIL_ANSIBLE_TAR) ;\
	else \
		@echo "No artifact found, getting the code from git repo" ; \
		$(eval BUILD_CONTRAIL_ANSIBLE_TAR := yes) ; \
	fi
else
	$(eval BUILD_CONTRAIL_ANSIBLE_TAR := yes)
endif

	if [ -n "$(BUILD_CONTRAIL_ANSIBLE_TAR)" ]; then \
		echo "Building from repo $(CONTRAIL_ANSIBLE_REPO) ref: $(CONTRAIL_ANSIBLE_REF)"; \
		git clone $(CONTRAIL_ANSIBLE_REPO) $(CONTRAIL_ANSIBLE) ;\
		cd $(CONTRAIL_ANSIBLE) ;\
		git checkout $(CONTRAIL_ANSIBLE_REF) ;\
		git reset --hard; \
		ansible-galaxy install -r requirements.yml -p playbooks/roles/ ;\
		rm -fr .git* ;\
		cd .. ; \
		echo "Saving to $(CONTRAIL_ANSIBLE_TAR)";\
		tar zcf $(CONTRAIL_ANSIBLE_TAR) $(CONTRAIL_ANSIBLE); \
		rm -fr $(CONTRAIL_ANSIBLE);\
	fi


$(CONTRAIL_REPO_CONTAINER_TAR): $(CONTRAIL_INSTALL_PACKAGE)
	$(eval CONTRAIL_REPO_BUILD_ARGS := )
ifdef CONTRAIL_INSTALL_PACKAGE_TAR_URL
	$(eval CONTRAIL_REPO_BUILD_ARGS +=  --build-arg CONTRAIL_INSTALL_PACKAGE_TAR_URL=$(CONTRAIL_INSTALL_PACKAGE_TAR_URL) )
else
	$(error CONTRAIL_INSTALL_PACKAGE_TAR_URL is undefined)
endif

	$(eval CONTRAIL_REPO_BUILD_ARGS +=  $(http_proxy_build_arg))

ifdef SSHPASS
	$(eval CONTRAIL_REPO_BUILD_ARGS += --build-arg SSHPASS=$(SSHPASS) )
endif

ifdef SSHUSER
	$(eval CONTRAIL_REPO_BUILD_ARGS += --build-arg SSHUSER=$(SSHUSER))
endif

	@echo "Building Contrail repo container"
	cd docker/contrail_repo/; \
	docker build $(CONTRAIL_REPO_BUILD_ARGS) \
		-t $(CONTRAIL_REPO_CONTAINER):$(CONTRAIL_VERSION) .
	@echo "Starting contrail repo container"
	docker run -d -p $(CONTRAIL_REPO_PORT):1567 --name contrail-apt-repo $(CONTRAIL_REPO_CONTAINER):$(CONTRAIL_VERSION)
	@echo "Saving the container $(CONTRAIL_REPO_CONTAINER):$(CONTRAIL_VERSION)"
	docker save $(CONTRAIL_REPO_CONTAINER):$(CONTRAIL_VERSION) | gzip -c > $@

$(CONTRAIL_INSTALL_PACKAGE):
	@echo "Making Contrail packages"
	@echo "Copying /cs-shared/packages/$(CONTRAIL_INSTALL_PACKAGE) to build directory"
	touch $@

.PHONY: clean

clean:
	@echo "Cleaning the workspace"
	docker rm -f contrail-apt-repo | true
ifndef KEEP_IMAGES
	$(foreach i,$(CONTAINERS),docker rmi -f contrail-$(i):$(CONTRAIL_VERSION) | true;)
	docker rmi -f $(CONTRAIL_REPO_CONTAINER):$(CONTRAIL_VERSION) | true
endif
	rm -f $(CONTAINER_TARS) $(CONTRAIL_INSTALL_PACKAGE) $(CONTRAIL_REPO_CONTAINER_TAR) prep contrail-repo contrail-ansible

.PHONY: save

save: $(CONTAINER_TARS)
ifndef CONTAINER_SAVE_LOCATION
	$(error CONTAINER_SAVE_LOCATION is undefined)
endif
	@echo "Saving container images in $(CONTAINER_SAVE_LOCATION)"
	install -t  $(CONTAINER_SAVE_LOCATION) $(CONTAINER_TARS)
	install -t  $(CONTAINER_SAVE_LOCATION) $(CONTRAIL_REPO_CONTAINER_TAR)

.PHONY: push

push: $(CONTAINER_TARS)
ifdef CONTAINER_REGISTRY
		@for i in $(CONTAINERS); do\
			CONTAINER_NAME=contrail-$$i;\
			CONTAINER_TAG=$$(docker images | grep "^$$CONTAINER_NAME-$$OS " | awk '{print $$3}');\
			CONTAINER_REG_NAME=$$CONTAINER_REGISTRY/$$CONTAINER_NAME-$$OS:$$CONTRAIL_VERSION;\
			echo "Tagging container: docker tag $$CONTAINER_TAG $$CONTAINER_REG_NAME";\
			docker tag $$CONTAINER_TAG $$CONTAINER_REG_NAME;\
			echo "Pushing container: docker push $$CONTAINER_REG_NAME";\
			docker push $$CONTAINER_REG_NAME;\
		done
else
		$(error CONTAINER_REGISTRY is undefined)
endif
