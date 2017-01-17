# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

require 'yaml'

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-6.7"
  inventory = YAML.load(File.read('vagrant.yml'))
  inventory.each do |type, nodes|
    nodes.each_index do |i|
      config.vm.define "#{type}-#{i+1}" do |node|
        node.vm.network "private_network", ip: nodes[i]
        # we will use a controller instance to manage configuration
        # to closer map something production
        if type == 'ctl'
          node.vm.provision 'ansible_local' do |ansible|
            ansible.playbook = "main.yml"
            ansible.inventory_path  = 'inventory/vagrant.ini'
          end
        end
      end
    end
  end
end
