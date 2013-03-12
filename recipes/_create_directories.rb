pid_dir      = node['redisio']['pid_dir']
config_dir   = node['redisio']['config_dir']
data_dir     = node['redisio']['data_dir']
log_dir      = node['redisio']['log_dir']

user         = node['redisio']['user']
group        = node['redisio']['group']

directory config_dir do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

directory data_dir do
  owner user
  group group
  mode '0775'
  recursive true
  action :create
end

directory pid_dir do
  owner user
  group group
  mode '0755'
  recursive true
  action :create
end

directory log_dir do
  owner user
  group group
  mode '0755'
  recursive true
  action :create
end