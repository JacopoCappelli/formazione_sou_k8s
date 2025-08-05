Vagrant.configure("2") do |config|

  config.vm.define "rocky-node" do |rocky|
    rocky.vm.box = "generic/rocky9"
    rocky.vm.network "private_network", ip: "192.168.168.211"

    rocky.vm.provider "virtualbox" do |v|
      v.gui = false
      v.name = "rocky-vm"
      v.memory = "5024"
    end

    rocky.vm.provision "shell", inline: <<-SHELL
      sudo mkdir -p /usr/local/bin
      sudo chmod 755 /usr/local/bin

      sudo chmod 776 /var/run/docker.sock

      echo "[INFO] Aggiunta repo Kubernetes..."
      cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.33/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.33/rpm/doc/rpm-package-key.gpg
EOF

      echo "[INFO] Installazione kubectl..."
      sudo yum install -y kubectl

      echo "[INFO] Installazione Helm..."
      curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

      if ! command -v helm &> /dev/null
      then
          echo "Helm was not found after installation script. Attempting manual path check."
          if [ -f /usr/local/bin/helm ]; then
              echo "/usr/local/bin/helm exists, ensuring execute permissions."
              sudo chmod +x /usr/local/bin/helm
          else
              echo "Error: Helm binary not found at /usr/local/bin/helm after install script."
          fi
      else
          echo "Helm successfully found in PATH after installation."
      fi

      if ! grep -q 'export PATH="\$PATH:/usr/local/bin"' ~/.bashrc; then
          echo 'export PATH="$PATH:/usr/local/bin"' >> ~/.bashrc
      fi
      source ~/.bashrc
 
    SHELL

    rocky.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
    end

  end 
end 