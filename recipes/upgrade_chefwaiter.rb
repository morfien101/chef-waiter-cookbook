#############################################################################
# Run the recipe which will also reset the task incase of failure and it will
# run again in 5 minutes.
# We need access to the resources contained in here also.
include_recipe 'chef-waiter::install_chef_waiter'
#############################################################################
include_recipe 'chef-waiter::remove_chef_waiter'
include_recipe 'chef-waiter::deploy_config_file'
include_recipe 'chef-waiter::deploy_chef_waiter'

chefwaiter 'stop_backup_upgrade_task' do
  action :remove_scheduled_upgrade
end
