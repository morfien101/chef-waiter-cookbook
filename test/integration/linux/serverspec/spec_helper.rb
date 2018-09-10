require 'serverspec'
require 'json'

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
end

$node = JSON.parse(`ohai`)

def node
  $node
end

def windows?
  os[:family] == 'windows'
end

def upstart_platform?
  return true if node['platform'] == 'amazon'
  if node['platform'] == 'centos'
    return true if node['platform_version'] =~ /^6/
  end
  false
end
