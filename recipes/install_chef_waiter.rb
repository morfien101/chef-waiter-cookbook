#
# Cookbook Name:: chef-waiter
# Recipe:: install_chefwaiter
#

# If the file exists here we need to remove it since the triggers are
# based on completing the download of this file. If the download fails
# we are left in a situation that chef waiter is never installed.
file "#{node['chef-waiter']['download_directory']}/#{::Chefwaiter.compressed_file_name}" do
  action :delete
end

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

file "#{node['chef-waiter']['download_directory']}/#{::Chefwaiter.compressed_file_name}" do
  action :delete
end
