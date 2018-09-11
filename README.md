# Chef Waiter Cookbook

This cookbook will install and configure the Chef waiter service on both windows and linux servers.

## What is the chef waiter

The chef-waiter service is a wrapper around chef that will add an API to the chef client to allow runs and reporting.

See [Chef Waiter on GitHub]("https://github.com/morfien101/chef-waiter") for more details.

![penguin waiter](./README/waiter_T.png "penguin waiter")

## How to use the cookbook

1. Set the version of chef waiter to be installed in your environment files.
1. Set any configuration values you want.
1. Turn on the install toggle.
1. Include chef-waiter in your cookbook or runlist.

See below for attributes.

## Configuring the cookbook

### Downloading Chef Waiter

Chef waiter is downloaded from Github releases. It is also built using travis. This requies this cookbook to constract the URL when downloading with the version and build number.

These attributes do this.

| Attribute | Type | Example value |
---|---|---
`node['chef-waiter']['version']` | String | "1.0.15"
`node['chef-waiter']['travis_build']` | Integer | 38
`node['chef-waiter']['url_base']` | String | This is the git releases page. Change only if you fork the project.

### Feature toggles

The cookbook works using the prinicple of feature toggles.
The following feature toggles are available to you.

| Attribute | Type | Example value | Description
---|---|---|---
`node['chef-waiter']['feature']['enabled']` | Bool | true | Run the code to install and remove chef waiter.
`node['chef-waiter']['feature']['manage_firewall']` | Bool | true | Run the code to add or remove the firewall rules for chef waiter.
`node['chef-waiter']['feature']['deploy_config_file']` | Bool | true | Deploy an optional configuration files with supplied values.
`node['chef-waiter']['remove']` | Bool | false | Install or remove the chef waiter.

### Where does it go

The cookbook uses the following values to download and install the chef waiter.

When downloading the files the cookbook tries  to tidy up after itself and remove any temp files at the end of the run.

| Attribute | Type | Example value | Description
---|---|---|---
`node['chef-waiter']['config_dir']` | String | "/etc/chefwaiter" or "c:/Program Files/chefwaiter" | Where to put the configuration file.
`node['chef-waiter']['binary_path']` | String | "/usr/local/bin" or "c:/Program Files/chefwaiter" | Where to put the binary.
`node['chef-waiter']['logs_path']` | String | "/var/log/chefwaiter" or "c:/logs/chefwaiter" | Where should chef waiter store log files.
`node['chef-waiter']['download_directory']` | String | "/tmp" or "c:/temp" | where should chef download the files to while installing.

### Configuration file values

All values under the `node['chef-waiter']['config_file']` attribute will be pushed into the configuration file. 

__Chef makes no attempt to valid these values, so make sure they are correct.__

Example:

This:

```ruby
node['chef-waiter']['config_file']['state_table_size'] = 40
node['chef-waiter']['config_file']['periodic_chef_runs'] = true
node['chef-waiter']['config_file']['run_interval'] = 30
```

Will equal this:

```json
{
  "state_table_size": 40,
  "periodic_chef_runs": true,
  "run_interval": 30
}
```

## Supported Operating Systems

The cookbook tested to support the following OSs.

* Windows 2012
* CentOS 6
* CentOS 7
* Ubuntu 18.04

It could work on other OSs but has not been tested.

## Contributing

Fork, Change, Test and submit PR.