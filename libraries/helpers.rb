def os?(name)
  node['os'] == name
end

def centos_7?
  return false unless os? 'linux'
  node['platform'] == 'centos' && node['platform_version'] >= '7'
end

def which_at
  centos_7? ? '/bin/at' : '/usr/bin/at'
end

def which_chefclient
  centos_7? ? '/bin/chef-client' : '/usr/bin/chef-client'
end

module Chefwaiter
  # Defined twice because of the modules.
  # Chef::Recipe.os? is a private method.
  def self.os?(name)
    ::Chef.node['os'] == name
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
    link += "%2Btravis#{::Chef.node['chef-waiter']['travis_build']}"
    link += "/#{compressed_file_name}"
    link
  end

  def self.binary_name
    ::Chef.node['chef-waiter']['exec_name']
  end

  def self.binary_location
    s = ::File.join(::Chef.node['chef-waiter']['binary_path'], ::Chef.node['chef-waiter']['exec_name'])
    s += '.exe' if os?('windows')
    s
  end

  def self.service_version
    return '' unless executable_available? && service_installed?
    cmdstr = "\"#{binary_location}\" -v"

    # Chef 12 and 13 users will still use to the old code.
    # In chef 14 it ShellOut was remove.
    if ::Chef.node['packages']['chef']['version'] < "14"
      cmd = ::Chef::Mixin::ShellOut.shell_out(cmdstr)
    else
      cmd = ::Chef::Mixin::ShellOut.shell_out_command(cmdstr)
    end
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