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

default['redisio']['config']['daemonize']                   = "yes"
default['redisio']['config']['piddir']                      = '/var/run/redis'
default['redisio']['config']['port']                        = "6379"
default['redisio']['config']['bind']                        = nil

default['redisio']['config']['unixsocket']                  = nil
default['redisio']['config']['unixsocketperm']              = nil
default['redisio']['config']['timeout']                     = "0"
default['redisio']['config']['tcp_keepalive']               = "0"

default['redisio']['config']['loglevel']                    = "notice"
default['redisio']['config']['logfile']                     = "stdout"
default['redisio']['config']['syslog_enabled']              = nil
default['redisio']['config']['syslog_ident']                = nil

default['redisio']['config']['syslog_facility']             = nil
default['redisio']['config']['databases']                   = "16"
default['redisio']['config']['save']                        = ["900 1", "300 10", "60 10000"]
default['redisio']['config']['stop_writes_on_bgsave_error'] = "yes"

default['redisio']['config']['rdbcompression']              = "yes"
default['redisio']['config']['rdbchecksum']                 = "yes"
default['redisio']['config']['dbfilename']                  = "dump.rdb"
default['redisio']['config']['dir']                         = "/var/lib/redis"

default['redisio']['config']['slaveof']                     = nil
default['redisio']['config']['masterauth']                  = nil
default['redisio']['config']['slave_serve_stale_data']      = "yes"
default['redisio']['config']['slave_read_only']             = "yes"

default['redisio']['config']['repl_ping_slave_period']      = nil
default['redisio']['config']['repl_timeout']                = nil
default['redisio']['config']['repl_disable_tcp_nodelay']    = "no"
default['redisio']['config']['slave_priority']              = "100"

default['redisio']['config']['requirepass']                 = nil
default['redisio']['config']['rename_command']              = nil # Array
default['redisio']['config']['maxclients']                  = nil
default['redisio']['config']['maxmemory']                   = nil

default['redisio']['config']['maxmemory_policy']            = nil
default['redisio']['config']['maxmemory_samples']           = nil
default['redisio']['config']['appendonly']                  = "no"
default['redisio']['config']['appendfilename']              = nil

default['redisio']['config']['appendfsync']                 = "everysec"
default['redisio']['config']['no_appendfsync_on_rewrite']   = "no"
default['redisio']['config']['auto_aof_rewrite_percentage'] = "100"
default['redisio']['config']['auto_aof_rewrite_min_size']   = "64mb"

default['redisio']['config']['lua_time_limit']              = "5000"
default['redisio']['config']['slowlog_log_slower_than']     = "10000"
default['redisio']['config']['slowlog_max_len']             = "128"
default['redisio']['config']['hash_max_ziplist_entries']    = "512"

default['redisio']['config']['hash_max_ziplist_value']      = "64"
default['redisio']['config']['list_max_ziplist_entries']    = "512"
default['redisio']['config']['list_max_ziplist_value']      = "64"
default['redisio']['config']['set_max_intset_entries']      = "512"

default['redisio']['config']['zset_max_ziplist_entries']    = "128"
default['redisio']['config']['zset_max_ziplist_value']      = "64"
default['redisio']['config']['activerehashing']             = "yes"
default['redisio']['config']['client_output_buffer_limit']  = ["normal 0 0 0", "slave 256mb 64mb 60", "pubsub 32mb 8mb 60"]

default['redisio']['config']['hz']                          = "10"
default['redisio']['config']['include']                     = nil # Array

# So we know what we can re-apply dynamically
default['redisio']['runtime_configurable_settings'] = ['allkeys_lru', 'allkeys_random', 'appendfsync', 'appendonly', 'auto_aof_rewrite_min_size', 'auto_aof_rewrite_percentage', 'client_output_buffer_limit', 'dbfilename', 'dir', 'hash_max_ziplist_entries', 'hash_max_ziplist_value', 'list_max_ziplist_entries', 'list_max_ziplist_value', 'loglevel', 'lua_time_limit', 'masterauth', 'maxmemory', 'maxmemory_policy', 'maxmemory_samples', 'no_appendfsync_on_rewrite', 'noeviction', 'notice', 'rdbchecksum', 'rdbcompression', 'repl_ping_slave_period', 'repl_timeout', 'requirepass', 'save', 'set_max_intset_entries', 'slave_priority', 'slave_read_only', 'slave_serve_stale_data', 'slowlog_log_slower_than', 'slowlog_max_len', 'stop_writes_on_bgsave_error', 'timeout', 'volatile_random', 'volatile_ttl', 'watchdog_period', 'zset_max_ziplist_entries', 'zset_max_ziplist_value']