  
myappName = "myapp"

install_path = "#{ENV['HOME']}/cheftest/helloworldapp"
resource_path = install_path
myapp_tar_path = "#{resource_path}/#{myappName}.tar.gz"

Chef::Log.info("** install_path=#{install_path}")
Chef::Log.info("** myapp_tar=#{myappName}")

directory "#{install_path}/conf" do
      mode "0775"
      action :create
      recursive true
end

cookbook_file "#{install_path}/#{myappName}.tar.gz" do
  source "#{myappName}.tar.gz"
  mode 0755
end


script "install_myapp" do
  interpreter "bash"
  cwd "#{install_path}"
  code <<-EOH
  tar xvfz #{myapp_tar_path}
  rm #{install_path}/#{myappName}.tar.gz
  EOH
end

message = node[node[:env]]["helloworld"]["message"]

template "#{install_path}/conf/message.txt" do
  source "message.txt.erb"
  variables(
:message => message
)
  mode 0644
end

