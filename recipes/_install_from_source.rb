url          = node['redisio']['mirror']
base_name    = node['redisio']['base_name']
version      = node['redisio']['version']
extension    = node['redisio']['artifact_type']

tarball_name = "#{base_name}#{version}"
tarball      = "#{tarball_name}.#{extension}"
download_url = "#{url}/#{tarball}"

download_dir = node['redisio']['download_dir']
checksum     = node['redisio']['checksum']

# Install from source
remote_file "Download Redis Source" do
  path "#{download_dir}/#{tarball}"
  source download_url
  backup false
  checksum checksum
  notifies :run, "execute[Unpack Redis Tarball]", :immediately
  not_if { redis_exists? && node['redisio']['safe_install'] }
end

execute "Unpack Redis Tarball" do
  command "tar -xvzf #{tarball}"
  action :nothing
  cwd download_dir
  notifies :run, "execute[Make Redis]", :immediately
end

execute "Make Redis" do
  command "make clean && make"
  cwd "#{download_dir}/#{tarball_name}"
  action :nothing
  notifies :run, "execute[Install Redis]", :immediately
end

execute "Install Redis" do
  command "make install"
  cwd "#{download_dir}/#{tarball_name}"
  action :nothing
end