def os?(name)
  node['os'] == name
end

def centos_7?
  return false unless os? 'linux'
  node['platform'] == 'centos' && node['platform_version'] >= '7'
end

def which_at
  return '/bin/at' if ::File.exist?('/bin/at')
  return '/usr/bin/at' if ::File.exist?('/usr/bin/at')
  # Don't know where it is hope for a PATH env
  'at'
end

def which_chefclient
  return '/bin/chef-client' if ::File.exist?('/bin/chef-client')
  return '/usr/bin/chef-client' if ::File.exist?('/usr/bin/chef-client')
  # Don't know where it is hope for a PATH env
  'chef-client'
end

module Chefwaiter
  # Defined twice because of the modules.
  # Chef::Recipe.os? is a private method.
  def self.os?(name)
    ::Chef.node['os'] == name
  end

  def self.chef_version
    # chef on windows has a different name than linux.
    if os? 'windows'
      chef_package = ::Chef.node['packages'].select do |pkg_name|
        pkg_name =~ /[Cc]hef/
      end
      # We get back an array with a name that we don't know as it
      # has the version number in it.
      # Therefore we need to pull whatever we got out and use that.
      return chef_package[chef_package.keys.first]['version']
    end

    ::Chef.node['packages']['chef']['version']
  end

  # These platforms require upstart to run chef-waiter
  def self.upstart_platforms?
    return true if ::Chef.node['platform'] == 'amazon'
    if ::Chef.node['platform'] == 'centos'
      return true if ::Chef.node['platform_version'] =~ /^6/
    end
    false
  end

  # service_provider returns the chef service handler that chef should used
  # when dealing the with the service manager for chef-waiter.
  def self.service_provider
    return Chef::Provider::Service::Upstart if upstart_platforms?
  end

  # override_service_provider returns true if the platform should use a non-default
  # service handler.
  # Besure to set a handler in self.service_provider
  def self.override_service_provider?
    return true if upstart_platforms?
  end

  def self.linux_service_script_location
    return '/etc/init/chefwaiter.conf' if upstart_platforms?
    return '/etc/systemd/system/chefwaiter.service' if Dir.exist? '/etc/systemd'
    # Default sysV location
    '/etc/init.d/chefwaiter'
  end

  def self.directory_name
    "chef-waiter-#{::Chef.node['os']}-amd64-v#{::Chef.node['chef-waiter']['version']}"
  end

  def self.compressed_file_name
    return "#{directory_name}.zip" if os? 'windows'
    "#{directory_name}.tar.gz"
  end

  def self.download_link
    link = ::Chef.node['chef-waiter']['url_base']
    link += "/v#{::Chef.node['chef-waiter']['version']}"
    link += "/#{compressed_file_name}"
    link
  end

  def self.binary_name
    ::Chef.node['chef-waiter']['exec_name']
  end

  def self.binary_location
    ::File.join(::Chef.node['chef-waiter']['binary_path'], ::Chef.node['chef-waiter']['exec_name'])
  end

  def self.service_version
    return '' unless executable_available? && service_installed?
    cmdstr = "\"#{binary_location}\" -v"

    # Chef 12 and 13 users will still use to the old code.
    # In chef 14 it ShellOut was remove.
    cmd = chef_version < '14' ? ::Chef::Mixlib::ShellOut.new(cmdstr).run_command : ::Chef::Mixin::ShellOut.shell_out_command(cmdstr)
    cmd.stdout.chomp
  end

  def self.executable_available?
    ::File.exist?(binary_location)
  end

  def self.service_installed?
    os?('windows') ? ::Win32::Service.exists?('chefwaiter') : ::File.exist?(linux_service_script_location)
  end

  def self.update_required?
    service_version != ::Chef.node['chef-waiter']['version']
  end
end
