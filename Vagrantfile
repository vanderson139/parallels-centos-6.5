require 'json'
require 'yaml'

VAGRANTFILE_API_VERSION = "2"

centosYamlPath = File.expand_path("CentOS.yaml")
afterScriptPath = File.expand_path("scripts/after.sh")
aliasesPath = File.expand_path("scripts/aliases")
iniPath = File.expand_path("scripts/php.ini")

require_relative 'scripts/centos.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	if File.exists? aliasesPath then
		config.vm.provision "file", source: aliasesPath, destination: "~/.bash_aliases"
	end

	if File.exists? iniPath then
      config.vm.provision "file", source: iniPath, destination: "~/php.ini"
    end

	CentOS.configure(config, YAML::load(File.read(centosYamlPath)))

	if File.exists? afterScriptPath then
		config.vm.provision "shell", path: afterScriptPath
	end
end
