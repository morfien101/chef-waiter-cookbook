#
# Cookbook Name:: chef-waiter
# Recipe:: install_chefwaiter
#

if ::Chefwaiter.service_installed?
  # If the service is installed we need to schedule an upgrade outside of a
  # chefwaiter managed run. This is because chefwaiter holds the process of
  # chef. If it stops so does chef.
  chefwaiter 'schedule_upgrade' do
    action :schedule_upgrade
  end
else
  # Else just go ahead and deploy the binary
  include_recipe 'chef-waiter::deploy_chef_waiter'
end
