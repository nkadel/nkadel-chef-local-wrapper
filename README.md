This tool is written as a template for a chef-local capable git
repository.

Copyright (C) 2015-2018 Nico Kadel-Garcia <nkadel@gmail.com>

* Clone git repository of
  https://github.com/nkadel/nkadel-chef-local-wrapper to personal
  github repo
* * Ideally use root owned repo at /var/chef-local/
* Create personal branch for local work
* Review chef-local config in "local.rb.in". local.rb is generated
  and pointed to local working directory. Template is below.
  * # Deploy in @@@PWD@@@, and link to /etc/chef-local.rb
  * # for chef-local to work by default
  * cookbook_path	'@@@PWD@@@/berks-cookbooks'
  * role_path	'@@@PWD@@@/roles'
  * data_bag_path	'@@@PWD@@@/data_bags'
  * environment_path	'@@@PWD@@@/environments'
  * # Deploy via separate channel, do not keep in git repo
  * encrypted_data_bag_secret	'@@@PWD@@@/encrypted_data_bag_secret'
* Create node configuration templates under nodes-local/
  * nodes-local/$HOSTNAME.json	for node specific config
  * nodes-local/[template].json.tmpl	 for templates based on hostname
  * nodes-local/default.json.tmpl	 for default template
* Create local cookboooks under cookbooks-local
  * cookbooks-local/[cookbook]
* Add local cookbooks to Berskfile
* Add external cookbooks in Berksfile
* Edit Makefile as needed to select templates for distinct hostnames
  * WARNING: Hostnames may need to be reset for consistency on images of previously chef managed hosts
* Use Makefile to assemble Berksfile.lock
  * Use "make" to deploy node, activeate Berkshelf, and run
    "chef-local" with all recipes and roles configured for the
    particular node.

The end result is that "chef-client" is run against the configurations
in the local directory. Since "chef-solo" was discarded, the run of
"chef-client" fully populates the "nodes/$HOSTNAME.json" file with the
complete attributes of the local node at run time. These
