require 'spec_helper'

describe service('chefwaiter') do
  it { should be_running }
  it { should have_start_mode('Automatic') }
end

describe file('c:\\Program Files\\chefwaiter\\config.json') do
  it { should be_file }
  its(:content) { should match /"state_table_size": 40,/ }
end

describe file('c:\\Program Files\\chefwaiter\\chef-waiter.exe') do
  it { should be_file }
end
