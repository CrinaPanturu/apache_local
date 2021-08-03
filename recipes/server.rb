#
# Cookbook Name:: apache
# Recipe:: server
#
# Copyright (c) 2021 The Authors, All Rights Reserved.

package 'httpd' do
  action :install
end

#file '/path/to/file' do
#  content 'here is my content'
#end

#file '/var/www/html/index.html' do
#  content "<h1>Hello, world!</h1>
#  <h2>IPADDRESS: #{node['ipaddress']} </h2>
#  <h2>HOSTNAME: #{node['hostname']} </h2>
#"
#end

remote_file '/var/www/html/image.png' do
  source 'https://i.pinimg.com/564x/f3/1a/41/f31a41a09ea8de42596984246eeab327.jpg'
end

# Notifies :action, 'resource[name]', :timer
# subscribes :action, 'resource[name]', :timer
# :before, :delayed, :immediately
# So we can make the template notify the service
# Or the service to be subscribed to the template's modifications

template '/var/www/html/index.html' do
  source 'index.html.erb'
  action :create
#  notifies :restart, 'service[httpd]', :immediately
end

#cookbook_file '/var/www/html/index.html' do
#  source 'index.html'
#end

#bash "inline script" do
#  user "root"
#  code "mkdir -p /var/www/mysites/ && chown -R apache /var/www/mysites/" 
  #without the guard properties (not_if, only_if) the chef won't check if the directory already exists, the owner etc.
  #not_if '[-d /var/www/mysites/]'
  #we can also check this using ruby:
#  not_if do
#    File.directory?('/var/www/mysites/')
#  end
#end

#execute "run a script" do
#  user 'root'
#  command <<-EOH
#  mkdir -p /var/www/mysites/
#  chown -R apache /var/www/mysites
#  EOH
#  not_if
#end

#We can use execute to run an already existing script
#execute 'run a script' do
#  user 'root'
#  command './my_script'
#  not_if
#end

#A better way to do this:
directory "/var/www/mysites" do
  owner 'apache'
  recursive true
end

service 'httpd' do
  action [:enable, :start]
  subscribes :restart, 'template[/var/www/html/index.html]', :immediately
end
