# Chef Waiter Cookbook

This cookbook will install and configure the Chef waiter service on both windows and linux servers.

The cookbook expects that you supply a version that need to be installed in the environment.

```ruby
node['chef-waiter']['version']
```

The cookbook also supplies a way to remove the chef waiter service.

By setting the value below to `true` the cookbook will remove the service and files from the computer.

```ruby
node['chef-waiter']['remove']
```

The cookbook will also open the required firewall ports. It supports windows firewall and iptables.

The cookbook tested to support the following OSs.

* Windows 2012
* CentOS 6
* CentOS 7
* Ubuntu 18.04

It could work on other OSs but has not been tested.

## How to use the cookbook

1. Set the version (as above) in your environment files.
2. Include chef-waiter in your cookbook or runlist.

## What is the chef waiter

The chef-waiter service is a wrapper around chef that will add an API to the chef client to allow runs and reporting.

See [Chef Waiter on GitHub]("https://github.com/morfien101/chef-waiter") for more details.

![penguin waiter](./README/waiter_T.png "penguin waiter")
