user         = node['redisio']['user']
group        = node['redisio']['group']
homedir      = node['redisio']['homedir']
shell        = node['redisio']['shell']


user "Create Redis User" do
  username user
  comment 'Redis Service Account'
  supports :manage_home => true
  home homedir
  shell shell
  system true
end

group "Create Redis Group" do
  group_name group
  members [user]
  action :create
  system true
end