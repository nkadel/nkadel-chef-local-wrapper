This tool is written as a template for a chef-zero capable git repository. 

Copyright (C) 2015-2017 Nico Kadel-Garcia <nkadel@gmail.com>

* Clone git repository of
  https://github.com/nkadel/nkadel-chef-zero-wrapper to personal
  github repo at /var/chef-zero/
* Create personal branch for local work
* Create chef-zero config in "zero.rb"
* Create chef-client config in "client.rb", symlinked to "zero.rb", to provide
  working second config file for chef-zero. Typical format below.
  * cookbook_path	'/var/chef-zero/berks-cookbooks'
  * role_path	'/var/chef-zero/roles'
  * data_bag_path	'/var/chef-zero/data_bags'
  * environment_path	'/var/chef-zero/environments'
  * * Deploy data bag via separate channel, do not keep in git repo
  * encrypted_data_bag_secret	'/etc/chef/encrypted_data_bag_secret'
* Create node configuration templates under nodes-local/
  * nodes-local/$HOSTNAME.json	for node specific config
  * nodes-local/[template].json.tmpl	 for templates based on hostname
  * nodes-local/default.json.tmpl	 for default template
* Create local cookboooks under cookbooks-local
  * cookbooks-local/[cookbook]
* Add local cookbooks to Berskfile
* Edit Makefile as needed to select templates for distinct hostnames
  * WARNING: Hostnames may need to be reset for consistency on images of previously chef managed hosts
* Use Makefile to assemble Berksfile.lock
  * Use "make" to deploy node, activeate Berkshelf, and run
    "chef-zero" with all recipes and roles configured for the
    particular node.

