# Deploy in /var/chef-zero, and link to /etc/chef-zero.rb
# for chef-zero to work by default
cookbook_path	'/var/chef-zero/berks-cookbooks'
role_path	'/var/chef-zero/roles'
data_bag_path	'/var/chef-zero/data_bags'
environment_path	'/var/chef-zero/environments'
# Deploy via separate channel, do not keep in git repo
encrypted_data_bag_secret	'/etc/chef/encrypted_data_bag_secret'
