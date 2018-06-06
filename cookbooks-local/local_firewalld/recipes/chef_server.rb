#
# Cookbook:: local_firewalld
# Recipe:: chef_server
#
# Copyright:: 2018, The Authors, All Rights Reserved.

firewalld_service 'http' do
  action :add
  zone 'public'
end

firewalld_service 'https' do
  action :add
  zone 'public'
end

firewalld_port '9683/tcp' do
  action :add
  zone 'public'
end

