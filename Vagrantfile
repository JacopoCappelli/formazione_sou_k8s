Vagrant.configure("2") do |config|

  config.vm.define "rocky-node" do |rocky|
    rocky.vm.box = "generic/rocky9"
    rocky.vm.network "private_network", ip: "192.168.168.211"

    rocky.vm.provider "virtualbox" do |v|
      v.gui = false
      v.name = "rocky-vm"
      v.memory = "5024"
    end 

    rocky.vm.provision "shell" , inline: "sudo chmod 776 /var/run/docker.sock"

    rocky.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
    end 
  end 

end