name             'chef-waiter'
maintainer       'NewVoiceMedia'
maintainer_email 'nvm_automation_team@newvoicemedia.com'
license          'Apache-2.0'
description      'Installs/Configures the Chef Waiter service'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.1.0'

source_url 'https://github.com/morfien101/chef-waiter-cookbook' if respond_to?(:source_url)

{
  'ubuntu' => '18.04',
  'centos' => ['6', '7'],
  'amazonlinux' =>  '',
  'windows' => '2012',
}.each do |os, version|
  def support(o, v)
    supports o, "= #{v}"
  end

  if version.is_a? Array
    version.each do |v|
      support os, v
    end

    break
  end

  if version.empty?
    support os
    break
  end

  support os, version
end

depends 'iptables'
depends 'zipfile', '~> 0.2.0'
depends 'windows'
depends 'windows_firewall'
