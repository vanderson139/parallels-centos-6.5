class CentOS
  def CentOS.configure(config, settings)
    # Configure The Box
    config.vm.box = "parallels/centos-6.5"
    config.vm.hostname = "CentOS"

    # Configure A Private Network IP
    config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.10"

    # Configure A Few VirtualBox Settings
    config.vm.provider "parallels" do |v|
      v.name = 'CentOS'
      v.memory = settings["memory"] ||= "2048"
      v.cpus = settings["cpus"] ||= "1"
      # v.update_guest_tools = true
    end

    # Install base dependencies
    config.vm.provision "shell", path: 'scripts/dependencies.sh'
    
    # Configure The Public Key For SSH Access
    config.vm.provision "shell" do |s|
      s.inline = "echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
      s.args = [File.read(File.expand_path(settings["authorize"]))]
    end

    # Copy The SSH Private Keys To The Box
    settings["keys"].each do |key|
      config.vm.provision "shell" do |s|
        s.privileged = false
        s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
        s.args = [File.read(File.expand_path(key)), key.split('/').last]
      end
    end

    # Register All Of The Configured Shared Folders
    settings["folders"].each do |folder|
      config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil
    end
  end
end
