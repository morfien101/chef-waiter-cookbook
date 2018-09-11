#
# Cookbook Name:: chef-waiter
# Recipe:: remove_chefwaiter
#

service 'chefwaiter' do
  supports status: true
  action [:stop]
  provider ::Chefwaiter.service_provider if ::Chefwaiter.override_service_provider?
  only_if { ::Chefwaiter.executable_available? }
end

execute 'Remove Chef Waiter Service' do
  command %("#{::Chefwaiter.binary_location}" --service uninstall)
  action :run
  only_if { ::Chefwaiter.executable_available? }
end

# Delete the file and remove the firewall rule.
file ::Chefwaiter.binary_location do
  action :delete
end

# Remove the configuration directory if it was deployed.
directory node['chef-waiter']['config_dir'] do
  recursive true
  action :delete
end
