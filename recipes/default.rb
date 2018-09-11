#
# Cookbook Name:: chef-waiter
# Recipe:: default
#

# Firewalls are always run and have their own feature toggle
include_recipe 'chef-waiter::configure_firewall'

# Chef waiter shold be toggled to install as it changes how chef works
if node['chef-waiter']['feature']['enabled']
  if node['chef-waiter']['remove']
    # Uninstall needs to be done in a seperate run as killing chefwaiter
    # will kill the run that is uninstalling it.
    chefwaiter 'schedule uninstall' do
      action :schedule_uninstall
    end
  else
    include_recipe 'chef-waiter::deploy_config_file'
    include_recipe 'chef-waiter::install_chef_waiter'
  end
end
