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
actions :install, :enable
default_action :install if defined?(default_action) # Chef > 10.8

# Big hack below to work around this line not working
# attribute :version, :kind_of => String, :default => node['redisio']['version']

# Installation attributes
attribute :server_name, :kind_of => String, :name_attribute => true
attribute :download_url, :kind_of => String
attribute :download_dir, :kind_of => String, :default => Chef::Config[:file_cache_path]
attribute :artifact_type, :kind_of => String, :default => 'tar.gz'
#attribute :base_name, :kind_of => String, :default => 'redis-'
attribute :safe_install, :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :base_piddir, :kind_of => String, :default => '/var/run/redis'

def initialize(*args)
  super
  @action = :install
end

# Here be dragons
def _set_attribute_value(arg, attribute_name, kind_of)
  # We now have access to the merged node attributes, so lets get our value that
  # is the result of default/normal/override/ohai merging.
  default_set_in_attributes = run_context.node['redisio'][attribute_name]
  Chef::Log.debug("Default #{attribute_name} is #{default_set_in_attributes}")

  # If there is a value passed in to the resource block, it is available
  # as an instance variable of the same name, so lets introspect ourself to
  # get that value
  value_from_resource_block = self.instance_variable_get("@#{attribute_name}")

  # Here is where we merge all of our settings.  We use `arg` if it is not
  # null.  After that we use a value passed in to the resource block if
  # available.  Finally we fall back to using the value set in the node 
  # attributes.
  if arg == nil
    arg = value_from_resource_block ||= default_set_in_attributes
  end
  Chef::Log.debug("Merged #{attribute_name} is #{arg}")

  # Coup de Grace, call set_or_return to actually set the value we spent so much
  # time finding.  We need to convert the name to a symbol so it can get 
  # assigned.  We also need to pass along the type,
  set_or_return(
    attribute_name.to_sym,
    arg,
    :kind_of => kind_of
  )
end

# Manually define all of the attributes because we cannot dynamically generate
# them at runtime since the node is not converged and we do not have our
# attributes
def version(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def datadir(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def piddir(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def logdir(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def configdir(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def user(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def group(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def homedir(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def shell(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def systemuser(arg=nil)
   _set_attribute_value(arg, __method__, [TrueClass, FalseClass])
end

def ulimit(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def name(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def address(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def address(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def databases(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def backuptype(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def unixsocket(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def unixsocketperm(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def port(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def timeout(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def loglevel(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def logfile(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def syslog_enabled(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def syslog_ident(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def syslog_facility(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def shutdown_save(arg=nil)
   _set_attribute_value(arg, __method__, [TrueClass, FalseClass])
end

def save(arg=nil)
   _set_attribute_value(arg, __method__, Array)
end

def slaveof(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def masterauth(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def slaveservestaledata(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def replpingslaveperiod(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def repltimeout(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def requirepass(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def maxclients(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def maxmemory(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def maxmemorypolicy(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def maxmemorysamples(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def appendfsync(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def noappendfsynconrewrite(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def aofrewritepercentage(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def aofrewriteminsize(arg=nil)
   _set_attribute_value(arg, __method__, String)
end

def includes(arg=nil)
   _set_attribute_value(arg, __method__, String)
end