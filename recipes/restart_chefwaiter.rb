#
# Cookbook Name:: chef-waiter
# Recipe:: restart_chefwaiter
#

# This recipe is a simple restart service.
# Due to chef waiter holding the chef service process it can NOT be restart else the
# process for chef will be lost causing the chef waiter process to be left off.
# This means we need to run chef directly. This recipe is to be used by either windows
# tasks or the linux at deamon.

service 'chefwaiter' do
  action :restart
  supports status: true
  provider ::Chefwaiter.service_provider if ::Chefwaiter.override_service_provider?
  only_if { ::Chefwaiter.service_installed? }
end
