# Deploy in /var/chef-local, and link to /etc/chef-local.rb
# for chef-local to work by default
cookbook_path	'/var/chef-local/berks-cookbooks'
role_path	'/var/chef-local/roles'
data_bag_path	'/var/chef-local/data_bags'
environment_path	'/var/chef-local/environments'
# Deploy via separate channel, do not keep in git repo
encrypted_data_bag_secret	'/etc/chef/encrypted_data_bag_secret'
