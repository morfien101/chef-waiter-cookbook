name             'chef-waiter'
maintainer       'NewVoiceMedia'
maintainer_email 'nvm_automation_team@newvoicemedia.com'
license          'MIT'
description      'Installs/Configures the Chef Waiter service'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.1'

source_url 'https://github.com/morfien101/chef-waiter-cookbook' if respond_to?(:source_url)

depends 'iptables'
depends 'zipfile', '~> 0.2.0'
depends 'windows'
