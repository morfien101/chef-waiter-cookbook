name             'chef-waiter'
maintainer       'NewVoiceMedia'
maintainer_email 'nvm_automation_team@newvoicemedia.com'
license          'Apache-2.0'
description      'Installs/Configures the Chef Waiter service'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.3.2'

source_url 'https://github.com/morfien101/chef-waiter-cookbook' if respond_to?(:source_url)
issues_url 'https://github.com/morfien101/chef-waiter-cookbook/issues' if respond_to?(:issues_url)
# This is the lowest version that I have tested it on.
chef_version '>= 12.9.41'

# Very likely to support many more but this is what I have tested it with
supports 'ubuntu', '~> 18.04'
supports 'centos', '~> 6.0'
supports 'centos', '~> 7.0'
supports 'amazon'

# Tested with windows 2012R2 very likely to support more
supports 'windows'

depends 'iptables'
depends 'zipfile', '~> 0.2.0'
depends 'windows'
depends 'windows_firewall'
