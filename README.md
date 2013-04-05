## Description

Website:: https://github.com/brianbianco/redisio

Installs and configures Redis server instances

## Requirements

This cookbook builds redis from source, so it should work on any architecture for the supported distributions.  Init scripts are installed into /etc/init.d/
It depends on the following cookbooks

[ulimit](https://github.com/bmhatfield/chef-ulimit)
[sysctl](https://github.com/Fewbytes/sysctl-cookbook)

## Platforms

* Debian, Ubuntu
* CentOS, Red Hat, Fedora, Scientific Linux

Tested on:

* Ubuntu 12.04

## Usage

The *redisio* cookbook is divided into two primary parts.  A set of recipes for installation and a LWRP for configuration and service management.


### Installation

The *redisio* cookbook contains a recipe for installing redis from source.  The default installation setup can be found in `redisio::install`.

### Configuration

Configuration for individual Redis servers should be done with the LWRP.  For the LWRP, defaults will be drawn from the node attributes, although these may be overridden by specify values in the LWRP block.

In this diagram, attributes set higher up in the chain will be overridden by those set farther down.

```
Default Redis Configuration File
Default Node Attributes
Override Node Attributes
LWRP Attributes
```

*Redisio* provides a generic set of defaults that are close to the defaults from the [default](https://raw.github.com/antirez/redis/2.6/redis.conf) Redis configuraiton file.  Some exceptions:

`daemonize`: Set to `yes`, otherwise this would hang the Chef install.
`dir`: Uses `/var/lib/redis/` as the default file storage location.
`logfile`: Uses `/var/log/redis/#{server_name}.log` instead of `STDOUT`. 
`pidfile`: Uses `/var/run/redis/#{server_name}.pid`, the directory section comes from the `piddir` attribute.

These attributes are meant to be sane, but minimal.  The goal is for this cookbook to be used as an _"application cookbook"_ and [wrapped](http://devopsanywhere.blogspot.it/2012/11/how-to-write-reusable-chef-cookbooks.html) by your organization specific cookbook.  This will allow you to set organization wide defaults using override attributes.  However, Redis is a multitalented database so it is helpful to have granularity per server for configuration, this is where the use of LWRP attributes becomes essential. Some Examples...


#### Barebones Configuration

```ruby
include_recipe "redisio::install"

redisio "redis-server" do
  action [:configure, :enable, :start]
end
```

This will:

* Configure a server called `redis-server`
* Create a configuration file at `/etc/redis/redis-server.conf`
* Create a pid file at `/var/run/redis/redis-server.pid`
* Start the service
* Set the service to run on startup


#### Simple Slave Configuration

```ruby
include_recipe "redisio::install"

redisio "redis-server" do
  action [:configure, :enable, :start]
  slaveof "10.0.0.1 6379"  # Master Server's IP and Port
end
```

The only difference from the inital example is that this server will be a slave server, replicating from the master at the specified IP and Port.

### Dynamic Configuration

*Redisio* is able to dynamically configure your Redis server without restarting.  A list of configuration directives that can be applied dynamically are available in `default['redisio']['runtime_configurable_settings']` inside of `attributes/server_configuration.rb`.  By default, all potentially runtime configurable settings are enabled, though it is possible to override this list using the `override` directive in your node attributes.

Triggering of the dynamic configuration is done when the Redis Config template detects changes.  The reconfiguration iterates through all possible runtime directive and applies each in series using the `redis` gem.


License and Author
==================

Author:: [Andrew Gross] (<andrew.w.gross@gmail.com>)
Twitter:: @awgross
IRC:: awgross on freenode

This cookbook was originally adapted from the [Redisio Cookbook](https://github.com/brianbianco/redisio) from Brian Bianco.  The majority of the cookbook has been rewritten although `redis.init.erb` is mostly unmodified.


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

