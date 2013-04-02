include_recipe "redisio::_install_build_packages"

chef_gem "redis" do
  version "3.0.3"
  action :install
end

chef_gem "hiredis" do
  version "0.4.5"
  action :install
end
