# chef-waiter

This cookbook will install and configure the Chef waiter service on both windows and linux.

The cookbook expects that you supply a version that need to be installed in the environment file.

```ruby
node['chef-waiter']['version']
```

The cookbook also supplies a way to remove the chef waiter service.
By setting the value below to "true" the cookbook will remove the service and files from the computer.

```ruby
node['chef-waiter']['remove']
```

The cookbook tested to support the following OSs.

* Windows 2012
* CentOS 6
* CentOS 7
* Ubuntu 18.04

It could work on other OSs but has not been tested.

## How to use the cookbook

1. Set the version (as above) in your environment files.
2. Include chef-waiter in your cookbook or runlist.
