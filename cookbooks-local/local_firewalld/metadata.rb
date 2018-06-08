name 'local_firewalld'
maintainer 'Nico Kadel-Garcia'
maintainer_email 'nkadel@gmail.com'
license          'Apache v2.0'
description 'Installs/Configures local firewalld'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.1'
chef_version '>= 12.14' if respond_to?(:chef_version)

issues_url 'https://github.com/nkadel/nkadel-chef-local-wrapper'
source_url 'https://github.com/nkadel/nkadel-chef-local-wrapper'

depends 'firewalld'
