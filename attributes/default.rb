# Cookbook Name:: redisio
# Attribute::default
#
# Copyright 2013, Brian Bianco <brian.bianco@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

user = 'redis'
group = 'redis'

build_packages = ['tar', 'make', 'automake', 'gcc']

case node['platform']
when 'ubuntu','debian'
  shell = '/bin/false'
  homedir = '/var/lib/redis'
  # Change the default build packages for debian based systems
  build_packages = ['tar', 'build-essential']
when 'centos','redhat','scientific','amazon','suse'
  shell = '/bin/sh'
  homedir = '/var/lib/redis' 
when 'fedora'
  shell = '/bin/sh'
  homedir = '/home' 
  # This is necessary because selinux by default prevents the homedir from 
  # being managed in /var/lib/ 
else
  shell = '/bin/sh'
  homedir = '/redis'
end

default['redisio']['build_packages'] = build_packages

# Set VM Overcommit Memory for Redis
default['sysctl']['vm']['overcommit_memory'] = 1

# Tarball and download related defaults
default['redisio']['mirror'] = "https://redis.googlecode.com/files"
default['redisio']['base_name'] = 'redis-'
default['redisio']['artifact_type'] = 'tar.gz'
default['redisio']['version'] = '2.6.10'
default['redisio']['checksum'] = '7c8ac91c2607ae61e2b50a9a7df25120af6df364'
default['redisio']['download_dir'] = Chef::Config[:file_cache_path]

default['redisio']['safe_install'] = true
default['redisio']['job_control'] = 'initd'

default['redisio']['datadir'] = '/var/lib/redis'
default['redisio']['piddir'] = '/var/run/redis'
default['redisio']['configdir'] = '/etc/redis'

# Default Redis configuration Settings
default['redisio']['user'] = user
default['redisio']['group'] = group
default['redisio']['homedir'] = homedir
default['redisio']['shell'] = shell

default['redisio']['systemuser'] = true
default['redisio']['ulimit'] = '0'
default['redisio']['name'] = nil
default['redisio']['address'] = nil

default['redisio']['address'] = nil
default['redisio']['databases'] = '16'
default['redisio']['backuptype'] = 'rdb'
default['redisio']['unixsocket'] = nil

default['redisio']['unixsocketperm'] = nil
default['redisio']['port'] = '6379'
default['redisio']['timeout'] = '0'
default['redisio']['loglevel'] = 'verbose'

default['redisio']['logfile'] = "/var/log/redis/redis.log"
default['redisio']['syslog-enabled'] = 'no'
default['redisio']['syslog-ident'] = 'redis'
default['redisio']['syslog-facility'] = 'local0'

default['redisio']['shutdown_save'] = false
default['redisio']['save'] = ['900 1','300 10','60 10000']
default['redisio']['slaveof'] = nil
default['redisio']['masterauth'] = nil

default['redisio']['slaveservestaledata'] = 'yes'
default['redisio']['replpingslaveperiod'] = '10'
default['redisio']['repltimeout'] = '60'
default['redisio']['requirepass'] = nil

default['redisio']['maxclients'] = '10000'
default['redisio']['maxmemory'] = nil
default['redisio']['maxmemorypolicy'] = 'volatile-lru'
default['redisio']['maxmemorysamples'] = '3'

default['redisio']['appendfsync'] = 'everysec'
default['redisio']['noappendfsynconrewrite'] = 'no'
default['redisio']['aofrewritepercentage'] = '100'
default['redisio']['aofrewriteminsize'] = '64mb'

default['redisio']['includes'] = nil