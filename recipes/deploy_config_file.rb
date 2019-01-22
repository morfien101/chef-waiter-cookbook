#
# Cookbook Name:: chef-waiter
# Recipe:: deploy_config_file
#

# We only need to restart if the configuration file changes.
chefwaiter 'restart' do
  action :nothing
end

directory node['chef-waiter']['config_dir'] do
  action :create
  recursive true
end

template ::File.join(node['chef-waiter']['config_dir'], 'config.json') do # ~FC009 #~FC032
  source 'config.json.erb'
  action :create
  variables configuration_settings: node['chef-waiter']['config_file']
  only_if { node['chef-waiter']['feature']['deploy_config_file'] }
  notifies :schedule_restart, 'chefwaiter[restart]', :immediately
end
