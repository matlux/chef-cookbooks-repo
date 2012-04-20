



numberOfInstanceReq = node[:tomcat][:instanceReq]

(1..numberOfInstanceReq).each do |i|
  Chef::Log.info("** i=#{i}")


	tomcat_home = "#{node[:global][:deploydir]}/#{node[:tomcat][:role_sub_dir]}/instance#{i}"
	resource_path = "#{node[:global][:resourcedir]}"
	
	Chef::Log.info("** tomcat_home#{tomcat_home}")
	
	script "start_instance_#{i}" do
	  interpreter "bash"
	  user "vr"
	  cwd "#{tomcat_home}"
	  code <<-EOH
	  bin/startup.sh
	  EOH
	end


end