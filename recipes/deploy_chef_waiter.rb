#
# Cookbook Name:: chef-waiter
# Recipe:: deploy_chef_waiter
#

directory node['chef-waiter']['binary_path'] do
  recursive true
  action :create
end

file ::Chefwaiter.compressed_file_name do
  action :nothing
end

directory node['chef-waiter']['download_directory']

# Empty resources that will be triggered after download
directory "#{node['chef-waiter']['download_directory']}/#{::Chefwaiter.directory_name}" do
  action :nothing
  recursive true
end

zipfile "#{node['chef-waiter']['download_directory']}/#{::Chefwaiter.compressed_file_name}" do
  action :nothing
end

execute 'extract_chef_waiter' do
  action :nothing
  command "tar -C \"#{node['chef-waiter']['download_directory']}\" -xzvf #{node['chef-waiter']['download_directory']}/#{::Chefwaiter.compressed_file_name}"
end

remote_file ::Chefwaiter.binary_location do
  source "file://#{node['chef-waiter']['download_directory']}/#{::Chefwaiter.directory_name}/#{::Chefwaiter.binary_name}"
  owner 'root'
  group 'root'
  mode '0755'
  action :nothing
end

remote_file "#{node['chef-waiter']['download_directory']}/#{::Chefwaiter.compressed_file_name}" do
  source ::Chefwaiter.download_link
  action :create
  only_if { ::Chefwaiter.update_required? }

  # trigger extraction after successful download
  notifies :extract, "zipfile[#{node['chef-waiter']['download_directory']}/#{::Chefwaiter.compressed_file_name}]", :immediately if os? 'windows'
  notifies :run, 'execute[extract_chef_waiter]', :immediately unless os? 'windows'
  notifies :create, "remote_file[#{::Chefwaiter.binary_location}]", :immediately

  # Clean up after ourselves
  notifies :delete, "file[#{::Chefwaiter.compressed_file_name}]", :delayed
  notifies :delete, "directory[#{node['chef-waiter']['download_directory']}/#{::Chefwaiter.directory_name}]"
end

execute 'Install Chef Waiter Service' do
  command %("#{::Chefwaiter.binary_location}" --service install)
  action :run
  only_if { ::Chefwaiter.executable_available? }
  only_if { ::Chefwaiter.update_required? }
end

service 'chefwaiter' do
  action [:enable, :start]
  supports status: true
  provider ::Chefwaiter.service_provider if ::Chefwaiter.override_service_provider?
end
