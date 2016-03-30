# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # set to false, if you do NOT want to check the correct VirtualBox Guest Additions version when booting this box
  if defined?(VagrantVbguest::Middleware)
    config.vbguest.auto_update = true
  end

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http = "http://10.0.0.1:8123"
    config.proxy.https = "http://10.0.0.1:8123/"
    config.proxy.no_proxy = "localhost,192.168.1.0/24,127.0.0.1,10.0.0.0/24,.example.com"
  end

  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
  # config.vm.network :forwarded_port, guest: 5601, host: 5601
  # config.vm.network :forwarded_port, guest: 9200, host: 9200
  # config.vm.network :forwarded_port, guest: 9300, host: 9300

  config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", "1", "--memory", "1024"]
  end

  config.vm.provider "vmware_fusion" do |v, override|
     ## the puppetlabs ubuntu 14-04 image might work on vmware, not tested? 
    v.provision "shell", path: 'ubuntu.sh'
    v.box = "phusion/ubuntu-14.04-amd64"
    v.vmx["numvcpus"] = "2"
    v.vmx["memsize"] = "2048"
  end
  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end
  config.vm.provision "shell", path: 'setup.sh'
  (1..2).each do |i|
    config.vm.define "node-#{i}" do |node|
      config.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file = "default.pp"
        puppet.facter["node_name"] = "es-#{i}"
      end
      node.vm.network :forwarded_port, guest: 9200, host: 9200+i
      node.vm.network :forwarded_port, guest: 5601, host: 5601+i
      node.vm.network "private_network", ip: "10.0.0.1#{i}"
      node.vm.provision "shell",
                        inline: "echo hello from node #{i}"
    end
  end
end
