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
  variables ({
    state_table_size: node['chef-waiter']['config_file']['state_table_size'],
    periodic_chef_runs: node['chef-waiter']['config_file']['periodic_chef_runs'],
    run_interval: node['chef-waiter']['config_file']['run_interval'],
    debug: node['chef-waiter']['config_file']['debug'],
    logs_location: node['chef-waiter']['config_file']['logs_location'],
    state_location: node['chef-waiter']['config_file']['state_location'],
  })
  only_if { node['chef-waiter']['feature']['deploy_config_file'] }
  notifies :schedule_restart, 'chefwaiter[restart]', :immediately
end
