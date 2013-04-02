#
# Cookbook Name:: redisio
# Resource::install
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

module Redisio
  module Helper

    def redis_exists?
      exists = Mixlib::ShellOut.new("which redis-server")
      exists.run_command
      exists.exitstatus == 0 ? true : false 
    end

    def get_max_memory(node)
      node_memory_kb = node["memory"]["total"]
      node_memory_kb.slice! "kB"
      node_memory_kb = node_memory_kb.to_i

      maxmemory = node['redisio']['maxmemory']
      if maxmemory && maxmemory.include?("%")
        # Just assume this is sensible like "95%" or "95 %"
        percent_factor = maxmemory.to_f / 100.0
        # Ohai reports memory in KB as it looks in /proc/meminfo
        maxmemory = (node_memory_kb * 1024 * percent_factor).to_i
      end   
      maxmemory   
    end

    def get_descriptors(node)
      ulimit = node['redisio']['ulimit'].to_i
      maxclients = node['redisio']['config']['maxclients'].to_i
      descriptors = ulimit == 0 ? maxclients + 32 : maxclients
      descriptors
    end

    def get_redis_context(node, nr)
      redis_context = Hash.new
      
      node['redisio']['config'].each do |k,v|
        begin
          redis_context[k] = new_resource.send(k.to_sym)
        rescue NoMethodError
          Chef::Log.debug("#{nr} No Method found for #{k.to_sym}")
        end
      end
      redis_context['maxmemory'] = get_max_memory(node)
      redis_context['name'] = new_resource.server_name
      redis_context['pidfile'] = "#{redis_context['piddir']}/#{redis_context['name']}.pid"
      redis_context['logfile'] = "#{redis_context['logdir']}/#{redis_context['name']}.log"
      redis_context = redis_context.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      Chef::Log.debug(redis_context.inspect)
      redis_context
    end

    def redis_running?(port)
      command = "netstat -plunt | grep redis | grep #{port}"
      result = %x[#{command}]
      Chef::Log.debug("Redis Running on port #{port}? #{!!result}")
      !!result
    end

    def has_convertable_suffix?(string)
      convertible_suffixes = ['k', 'm', 'g', 'kb', 'mb', 'gb']
      return convertible_suffixes.any? { |suffix| string.scan(/#{suffix}$/) }
    end

    def convert_suffix(string)
      value = string
      if has_convertable_suffix?(string.to_s)
        numeric_value = string.to_i
        suffix = string.to_s.sub(numeric_value.to_s, '')
        case suffix
        when "k"
          value = numeric_value * 1000
        when "m"
          value = numeric_value * 1000 * 1000
        when "g"
          value = numeric_value * 1000 * 1000 * 1000
        when "kb"
          value = numeric_value * 1024
        when "mb"
          value = numeric_value * 1024 * 1024
        when "gb"
          value = numeric_value * 1024 * 1024 * 1024
        end
      end
      return value.to_s
    end

    def reload_redis_config(config, port, node)
      require 'hiredis'
      require 'redis/connection/hiredis'
      require 'redis'

      Chef::Log.debug("Running Redis Config Reload for Port #{port}")

      rcs = node['redisio']['runtime_configurable_settings']

      redis = Redis.new(:host => "127.0.0.1", :port => port)
      config.each do |k,v|
        if rcs.include?(k.to_s) && v != nil 
          begin
            if v.kind_of?(Array)
              v = v.join(' ')
            end
            if k.to_s == "client_output_buffer_limit"
              v = v.split.collect!{ |a| convert_suffix(a) }.join(' ')
            end
            Chef::Log.debug("Setting config for #{k} to #{v}")
            redis.config('SET', [k.to_s.gsub(/_/,'-'), convert_suffix(v.to_s)])
          rescue Redis::CommandError => e
            Chef::Log.debug("Error setting config #{k} is: #{e}")
            raise e
          end  
        end
      end

    end

  end
end

self.class.send(:include, Redisio::Helper)
