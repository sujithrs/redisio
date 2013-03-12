include_recipe "redisio::install"

redisio "redis-server" do
  action :install
  version "2.6.10"
end

# # Create a service resource for each redis instance, named for the port it runs on.
# redis_instances.each do |current_server|
#   server_name = current_server['name'] || current_server['port']
#   job_control = current_server['job_control'] || redis['default_settings']['job_control'] 

#   if job_control == 'initd'
#     service "redis#{server_name}" do
#       start_command "/etc/init.d/redis#{server_name} start"
#       stop_command "/etc/init.d/redis#{server_name} stop"
#       status_command "pgrep -lf 'redis.*#{server_name}' | grep -v 'sh'"
#       restart_command "/etc/init.d/redis#{server_name} stop && /etc/init.d/redis#{server_name} start"
#       supports :start => true, :stop => true, :restart => true, :status => false
#     end
#   elsif job_control == 'upstart'
#     service "redis#{server_name}" do
#         provider Chef::Provider::Service::Upstart
#       start_command "start redis#{server_name}"
#       stop_command "stop redis#{server_name}"
#       status_command "pgrep -lf 'redis.*#{server_name}' | grep -v 'sh'"
#       restart_command "restart redis#{server_name}"
#       supports :start => true, :stop => true, :restart => true, :status => false
#     end
#   else
#     Chef::Log.error("Unknown job control type, no service resource created!")
#   end

# end
