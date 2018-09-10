require 'spec_helper'

describe iptables do
  it { should have_rule('-A CHEFWAITER -p tcp -m tcp --dport 8901 -j ACCEPT') }
  it { should have_rule('-A INPUT -j CHEFWAITER') }
end
