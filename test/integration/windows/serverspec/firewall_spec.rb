require 'spec_helper'

describe command('netsh advfirewall firewall show rule name="chef_waiter" dir=in') do
  its(:stdout) { should match /Direction:\s+In/ }
  its(:stdout) { should match /Enabled:\s+Yes/ }
  its(:stdout) { should match /Protocol:\s+TCP/ }
  its(:stdout) { should match /LocalPort:\s+8901$/ }
  its(:stdout) { should match /Action:\s+Allow/ }
end
