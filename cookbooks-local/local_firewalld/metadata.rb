name 'local_firewalld'
maintainer 'Nico Kadel-Garcia'
maintainer_email 'nkadel@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures local firewalld'
long_description 'Installs/Configures local firewalld'
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

# issues_url 'https://github.com/<insert_org_here>/local_firewalld/issues'
# source_url 'https://github.com/<insert_org_here>/local_firewalld'

depends 'firewalld'
