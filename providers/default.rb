#
# Cookbook Name:: redisio
# Provider::install
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

action :install do

  user = node['redisio']['user']
  group = node['redisio']['group']
  config_dir = node['redisio']['config_dir']
  server_name = new_resource.server_name
  descriptors = get_descriptors(node)

  # Setup the redis users descriptor limits
  user_ulimit user do
    filehandle_limit descriptors
  end
  
  # Template the Redis Config File for this server
  redis_context = get_redis_context(node, new_resource)

  template "#{config_dir}/#{server_name}.conf" do
    source 'redis.conf.erb'
    cookbook 'redisio'
    owner user
    group group
    mode '0644'
    variables(redis_context)
  end

end

action :enable do

  user = node['redisio']['user']
  group = node['redisio']['group']
  server_name = new_resource.server_name

  if node['redisio']['job_control'] == 'initd'
    owner = 'root'
    group = 'root'
    mode = 00755
    source = 'redis.init.erb'
    template_file = "/etc/init.d/#{server_name}" 
  elsif node['redisio']['job_control'] == 'upstart'
    owner = user
    group = group
    mode = 00644
    source = 'redis.upstart.conf.erb'
    template_file = "/etc/init/#{server_name}.conf" 
  end

  context = {
    :name          => server_name,
    :job_control   => node['redisio']['job_control'],
    :port          => node['redisio']['port'],
    :address       => node['redisio']['address'],
    :user          => node['redisio']['user'],
    :group         => node['redisio']['group'],
    :maxclients    => node['redisio']['maxclients'],
    :requirepass   => node['redisio']['requirepass'],
    :shutdown_save => node['redisio']['shutdown_save'],
    :save          => node['redisio']['save'],
    :configdir     => node['redisio']['configdir'],
    :piddir        => node['redisio']['piddir'],
    :platform      => node['platform'],
    :unixsocket    => node['redisio']['unixsocket']
  }

  template template_file do
    source source
    cookbook 'redisio'
    owner owner
    group group
    mode mode
    variables(context)
  end

end
