#
# Copyright (C) 2015-2017 Nico Kadel-Garcia <nkadel@gmail.com>
#
# Makefile for chef-zero - pull from git, run Berksfile, and run chef
#	Note logging of verbose log files in pull.out, chef-zero.out, etc.

# Berkshelf requires UTF capable LANG
LANG = en_US.UTF8

# Insist on using /bin/pwd for "make -C"
PWD = "`/bin/pwd`"

# Ensure components are installed
BERKS = /usr/bin/berks
CHEFZERO = /usr/bin/chef-zero
CHEFETCDIR = /etc/chef

# berks install puts cookbooks here, zero.rb finds them here
BERKSCOOKBOOKS = berks-cookbooks
# Default  foodcritic and testing tool location
COOKBOOKSLINK = cookbooks

# Node specific json file, if available
# Do not use $(HOSTNAME), not set for remote shell sesison
#HOST = `uname -n`
# Use --fqdn
HOST = `hostname --fqdn`
DEFAULTNODE = $(PWD)/nodes-local/default.json.tmpl
NODE = $(PWD)/nodes-local/$(HOST).json
# chef-zero configuration to find nodes, databags
ZERO = zero.rb
# chef-zero configuration for clients
CLIENT = client.rb

# chef-zero configured to use these by default
NODELINK = $(CHEFETCDIR)/node.json
ZEROLINK = $(CHEFETCDIR)/$(ZERO)
CLIENTLINK = $(CHEFETCDIR)/$(CLIENT)

BRANCH = "`git branch | grep ^'*' | awk '{print $$2}'`"

all: oscheck pull install vendor run

# Optional wrapper to merely set up local config symlinks
links: $(NODELINK) $(ZEROLINK) $(COOKBOOKSLINK) $(CLIENTLINK)

# Verify RHEL style OS, Amazon Linux uses /etc/os-release
.PHONY: oscheck
oscheck:
	@test -s /etc/redhat-release || test -s /etc/os-release

$(BERKS) $(CHEFZERO):
	@echo Error: $@ missing, install chefdk with RPM

# Default chef-zero location for config files
$(CHEFETCDIR):
	install -d -m770 -oroot -groot $@

.PHONY: pull
pull: .git /usr/bin/git
	@rm -f pull.out
	git pull --all | tee pull.out || \
	    git pull origin $(BRANCH) | tee pull.out

/usr/bin/git:
	@echo "Error: git missing, run 'yum install git'"
	@exit 1

.PHONY: berks
install: $(BERKS) Berksfile
	@rm -f install.out
	$(BERKS) install 2>&1 | tee install.out

.PHONY: vendor
vendor: $(BERKS)
	$(BERKS) vendor

# Set up node based on templates from symlinks
.PHONY: node
node: $(NODE)
$(NODE):
	@ echo setting up $(NODE)
	@case $(HOST) in \
	    template1-*) \
		echo "Linking template1.json.tmpl template to $(NODE)"; \
		ln -sf ../nodes-local/template1.json.tmpl $(NODE); \
		;; \
	esac

# Set up node based on templates from symlinks
.PHONY: nodelink
nodelink: $(NODELINK)
.PHONY: $(NODELINK)
$(NODELINK): $(CHEFETCDIR) $(NODE)
	@echo Checking link: $@
	@if [ -s "$(NODE)" ]; then \
	    if [ "`readlink --canonicalize $(NODELINK)`" != $(NODE) ]; then \
		echo "Setting $(NODE) link"; \
	        ln -sf $(NODE) $(NODELINK); \
	    fi; \
	else \
	    echo "Warning: $(NODE) not found, using $(DEFAULTNODE)"; \
	    if [ "`readlink --canonicalize $(NODELINK)`" != $(DEFAULTNODE) ]; then \
		echo "Setting $(DEFAULTNODE) link"; \
	        ln -sf $(DEFAULTNODE) $(NODELINK); \
	    fi; \
	fi

.PHONY: zerolink
zerolink: $(ZEROLINK)
.PHONY: $(ZEROLINK)
$(ZEROLINK): $(ZERO)
	@echo Checking link: $@
	@[ "`readlink --canonicalize $(ZEROLINK)`" = $(PWD)/$(ZERO) ] || \
	       ln -sf $(PWD)/$(ZERO) $(ZEROLINK)

.PHONY: clientlink
clientlink: $(CLIENTLINK)
.PHONY: $(CLIENTLINK)
$(CLIENTLINK): $(CLIENT)
	@echo Checking link: $@
	@[ "`readlink --canonicalize $(CLIENTLINK)`" = $(PWD)/$(CLIENT) ] || \
	       ln -sf $(PWD)/$(CLIENT) $(CLIENTLINK)

.PHONY: $(COOKBOOKSLINK)
$(COOKBOOKSLINK): $(BERKSCOOKBOOKS)
	@echo Checking link: $@
	@if [ "`readlink --canonicalize $(COOKBOOKSLINK)`" != $(PWD)/$(BERKSCOOKBOOKS) ]; then \
	    ln -sf $(PWD)/$(BERKSCOOKBOOKS) $(COOKBOOKSLINK); \
	fi

.PHONY: run
# Flush stacktraces before starting
# Leave obvious failure report at chef-zero.fail.out for auditing,
# move to chef-zero.out only on success
run: links
	@rm -f /var/cache/chef/chef-stackrace.out
	@rm -f chef-zero.out chef-zero.fail.out
	@echo
	@echo "Running: $(CHEFZERO) --config $(ZEROLINK) -j $(NODELINK), logs in chef-zero.out"
	$(CHEFZERO) --config $(ZEROLINK) -j $(NODELINK) 2>&1 | tee chef-zero.fail.out
	mv -f chef-zero.fail.out chef-zero.out

clean:
	rm -rf berks-cookbooks
	rm -f *.out

distclean: clean
	rm -rf nodes
	git clean -x -d -f

