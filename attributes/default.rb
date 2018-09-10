#
# Cookbook Name:: chef-waiter
# Attributes:: default
#

# Open source values
default['chef-waiter']['version'] = '1.0.15'
default['chef-waiter']['travis_build'] = 38
default['chef-waiter']['url_base'] = 'https://github.com/morfien101/chef-waiter/releases/download'

default['chef-waiter']['remove'] = false
default['chef-waiter']['exec_name'] = 'chef-waiter'

default['chef-waiter']['config_dir'] = '/etc/chefwaiter'
default['chef-waiter']['binary_path'] = '/usr/local/bin'
default['chef-waiter']['logs_path'] = '/var/log/chefwaiter'
default['chef-waiter']['download_directory'] = '/tmp'

# reset these if the OS is windows
if node['os'] == 'windows'
  default['chef-waiter']['config_dir'] = 'c:/Program Files/chefwaiter'
  default['chef-waiter']['binary_path'] = 'c:/Program Files/chefwaiter'
  default['chef-waiter']['logs_path'] = 'c:/logs/chefwaiter'
  default['chef-waiter']['download_directory'] = 'c:/temp'
  default['chef-waiter']['exec_name'] = 'chef-waiter.exe'
end

default['chef-waiter']['feature']['enabled'] = false
default['chef-waiter']['feature']['deploy_config_file'] = false
default['chef-waiter']['config_file']['state_table_size'] = 40
default['chef-waiter']['config_file']['periodic_chef_runs'] = true
default['chef-waiter']['config_file']['run_interval'] = 30
default['chef-waiter']['config_file']['debug'] = false
default['chef-waiter']['config_file']['logs_location'] = node['chef-waiter']['logs_path']
default['chef-waiter']['config_file']['state_location'] = node['chef-waiter']['binary_path']
