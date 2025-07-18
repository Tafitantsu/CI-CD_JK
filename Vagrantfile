Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.box_version = "202502.21.0"
  config.vm.box_check_update = true

  config.vm.hostname = "jenkins-server"

  config.vm.synced_folder "./jenkins", "/home/vagrant/jenkins",
    type: "rsync",
    create: true,
    rsync__auto: true
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "vmware_desktop" do |vm|
    vm.gui = true
    vm.memory = 4096
    vm.cpus = 2
  end

  config.vm.provision "shell",
    path: "docker_install.sh",
    name: "docker",
    privileged: false,
    run: "once"

  config.vm.provision "shell",
    path: "jenkins_install.sh",
    name: "jenkins",
    privileged: false,
    run: "once"
end
