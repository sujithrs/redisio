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

    def recipe_eval
      sub_run_context = @run_context.dup
      sub_run_context.resource_collection = Chef::ResourceCollection.new
      begin
        original_run_context, @run_context = @run_context, sub_run_context
        yield
      ensure
        @run_context = original_run_context
      end

      begin
        Chef::Runner.new(sub_run_context).converge
      ensure
        if sub_run_context.resource_collection.any?(&:updated?)
          new_resource.updated_by_last_action(true)
        end
      end
    end

    def version_to_hash(version_string)
      version_array = version_string.split('.') 
      version_array[2] = version_array[2].split("-")
      version_array.flatten!
      version_hash = { 
          :major => version_array[0],
          :minor => version_array[1],
          :tiny => version_array[2],
          :rc => version_array[3]
      }
      version_hash
    end

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
      ulimit = node['redisio']['ulimit']
      maxclients = node['redisio']['maxclients']
      descriptors = ulimit == 0 ? maxclients + 32 : maxclients
      descriptors
    end

    def get_redis_context(node, nr)
      redis_context = node['redisio'].clone
      redis_context['maxmemory'] = get_max_memory(node)
      redis_context['version'] = version_to_hash(node['redisio']['version'])
      redis_context['name'] = new_resource.server_name
      redis_context = redis_context.inject({}){|memo,(k,v)| memo[k.sub(/-/,'').to_sym] = v; memo}
      redis_context
    end

  end
end

self.class.send(:include, Redisio::Helper)
