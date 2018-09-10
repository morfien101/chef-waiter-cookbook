#
# Cookbook Name:: chef-waiter
# Recipe:: default
#

if os? 'windows'
  #windows_firewall 'chef_waiter' do
  #  direction :In
  #  firewall_action :Allow
  #  protocol :TCP
  #  enable	:Yes
  #  ports [8901]
  #  application_name ::File.join(node['chef-waiter']['binary_path'], "#{node['chef-waiter']['exec_name']}.exe").tr('/', '\\\\')
  #  description 'Chef Waiter service.'
  #  if node['feature']['chef-waiter']['enabled']
  #    action :add
  #  else
  #    action :delete
  #  end
  #  profile :DomainPrivate
  #end
else
  # Everything else we support uses iptables.
  include_recipe 'iptables'
  iptables_rule 'port_chefwaiter'
end

iptables_rule 'port_chefwaiter' do
  action :nothing
end unless os? 'windows'

if node['chef-waiter']['feature']['enabled']
  if node['chef-waiter']['remove']
    include_recipe 'chef-waiter::remove_chef_waiter'
  else
    include_recipe 'chef-waiter::deploy_config_file'
    include_recipe 'chef-waiter::install_chef_waiter'
  end
end
