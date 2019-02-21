# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

begin
  require_relative('settings')
  rescue LoadError
end

VM_CPUS   ||= 2
VM_MEMORY ||= 2048
VM_VRAM   ||= 128

# Array of strings
ANSIBLE_TAGS ||= nil
ANSIBLE_SKIP_TAGS ||= nil
ANSIBLE_START_AT_TASK ||= nil
ANSIBLE_GROUPS ||={}
ansible_groups = {
  "vagrant" => ["default"],
}
ansible_groups.merge!(ANSIBLE_GROUPS)

ANSIBLE_VAULT_PASSWORD_FILE ||= nil
ANSIBLE_VERBOSE ||= false

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # https://docs.vagrantup.com.

  config.vm.box = "debian/stretch64"
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  config.vagrant.plugins = "vagrant-vbguest"

  # VirtualBox specific stuff
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true

    vb.cpus   = VM_CPUS
    vb.memory = VM_MEMORY

    vb.customize ["modifyvm", :id, "--vram", VM_VRAM]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--device", "0", "--port", "0", "--nonrotational", "on", "--discard", "on"]
    # timesync equivalent to 2.5 minutes in ms)
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", "150000"]
  end

  # Use vagrant's default insecure key
  config.ssh.insert_key = false

  config.vm.provision "shell" do |s|
    s.inline = "apt-get install --yes --no-install-recommends python-apt"
    s.env = {
      'DEBIAN_FRONTEND' => 'noninteractive',
      'DEBIAN_PRIORITY' => 'critical'
    }
  end

  config.vm.provision "ansible" do |ansible|
   ansible.playbook = "ansible/site.yml"
   ansible.galaxy_command = "ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path}"
   ansible.galaxy_roles_path = 'ansible/galaxy_roles'
   ansible.galaxy_role_file = 'ansible/requirements.yml'
   ansible.groups = ansible_groups
   ansible.skip_tags = ANSIBLE_SKIP_TAGS
   ansible.start_at_task = ANSIBLE_START_AT_TASK
   ansible.tags = ANSIBLE_TAGS
   ansible.vault_password_file = ANSIBLE_VAULT_PASSWORD_FILE
   ansible.verbose = ANSIBLE_VERBOSE
  end
end
