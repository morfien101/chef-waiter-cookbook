#
# Cookbook Name:: chef-waiter
# Recipe:: configure_firewall
#

if os? 'windows'
  windows_firewall_rule 'chef_waiter' do
    dir :in
    firewall_action :allow
    protocol 'TCP'
    localport '8901'
    program ::File.join(node['chef-waiter']['binary_path'], "#{node['chef-waiter']['exec_name']}.exe").tr('/', '\\\\')
    description 'Chef Waiter service.'
    if node['chef-waiter']['feature']['enabled']
      action :create
    else
      action :delete
    end
    profile :any
    only_if { node['chef-waiter']['feature']['manage_firewall'] }
  end
else
  # Everything else we support uses iptables.
  include_recipe 'iptables'
  iptables_rule 'port_chefwaiter' do
    action node['chef-waiter']['feature']['enabled'] ? :enable : :disable
    only_if { node['chef-waiter']['feature']['manage_firewall'] }
  end
end
