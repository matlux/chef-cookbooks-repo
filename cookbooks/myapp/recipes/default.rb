


Chef::Log.info("******** test  node[:env]=#{node[:env]}")

node[:myapp].each do |param|
	Chef::Log.info("* node[:myapp]=#{param}")
end

#node[:override_attributes].each do |param|
#	Chef::Log.info("** node[:override_attributes]=#{param}")
#end
Chef::Log.info("** node[:recipes]=#{node[:recipes]}")
Chef::Log.info("** node[:roles]=#{node[:roles]}")
node[:chef_packages].each do |param|
	Chef::Log.info("** node[:chef_packages]=#{param}")
end

Chef::Log.info("** node[:hostname]=#{node[:hostname]}")
Chef::Log.info("** node[:fqdn]=#{node[:fqdn]}")
Chef::Log.info("** node[:ipaddress]=#{node[:ipaddress]}")
Chef::Log.info("** node[:macaddress]=#{node[:macaddress]}")
Chef::Log.info("** node[:env]=#{node[:env]}")

node[:global].each do |param|
	Chef::Log.info("** node[:global]=#{param}")
end

numberOfInstanceReq = node[:myapp][:instanceReq]

(1..numberOfInstanceReq).each do |i|
  Chef::Log.info("** i=#{i}")
  
	port = node[node[:env]]["myapp"]["base_port"] + i -1
	ssl_port = node[node[:env]]["myapp"]["base_ssl_port"] + i -1

	install_path = "#{ENV['HOME']}/#{node[:global][:deploydir]}/#{node[:myapp][:role_sub_dir]}/instance#{i}"
	resource_path = "#{ENV['HOME']}/#{node[:global][:resourcedir]}"
	myappName = "myapp"
	myapp_tar = "#{resource_path}/#{myappName}.tar.gz"
	
	Chef::Log.info("** install_path=#{install_path}")
	Chef::Log.info("** myapp_tar=#{myapp_tar}")
	
	directory "#{install_path}" do
	      action :delete
	      recursive true
	end
	
	directory "#{install_path}/conf" do
	      mode "0775"
	      action :create
	      recursive true
	end
	
	script "install_myapp" do
	  interpreter "bash"
	  cwd "#{install_path}"
	  code <<-EOH
	  if [ ! -e #{myapp_tar} ]; then
	  	echo node[:global][:resourcedir]=#{myapp_tar} file does not exist.
	  	exit 1
	  fi
	  tar xvfz #{myapp_tar}
	  #mv #{myappName}/* .
	  #rm -r #{myappName}
	  EOH
	end
	
	
	template "#{install_path}/conf/setenv.sh" do
	  source "setenv.sh.erb"
	  variables(
    	:port => port,
    	:ssl_port => ssl_port
  	)
	  mode 0644
	end


end

