require 'spec_helper'

describe service('chefwaiter') do
  it { should be_enabled }
  it { should be_running }
end unless upstart_platform?

describe command('cat /etc/init/chefwaiter.conf') do
  its(:stdout) { should match /start on stopped rc/ }
end if upstart_platform?

describe command('sudo status chefwaiter') do
  its(:stdout) { should match %r{start/running} }
end if upstart_platform?

describe file('/etc/chefwaiter/config.json') do
  it { should be_file }
  its(:content) { should match /"state_table_size": 40/ }
  its(:content) { should match /"metrics_enabled": true/ }
end

describe command('curl localhost:8901/status') {
  its(:stdout) { should match /"healthy": true/ }
}
