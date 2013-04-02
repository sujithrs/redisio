pid_dir      = node['redisio']['config']['piddir']
data_dir     = node['redisio']['config']['dir']
config_dir   = node['redisio']['configdir']
log_dir      = node['redisio']['logdir']

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