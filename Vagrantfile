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
# Debian Stretch and higher have Python3 by default
ansible_groups = {
  "vagrant" => ["default"],
  "python3" => ["default"],
  "python3:vars" => {
     "ansible_python_interpreter" => "/usr/bin/python3"
  }
}
ansible_groups.merge!(ANSIBLE_GROUPS)

ANSIBLE_VAULT_PASSWORD_FILE ||= nil
ANSIBLE_VERBOSE ||= false

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # https://docs.vagrantup.com.

  config.vm.box = "debian/buster64"
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  config.vm.provider "libvirt" do |v, override|
    v.cpus = VM_CPUS
    v.memory = VM_MEMORY
    v.graphics_type = "spice"
    v.keymap = "en-gb"
    v.video_type = "qxl"
    v.video_vram = 9216
    v.random :model => 'random'
    v.channel :type => 'unix', :target_name => 'org.qemu.guest_agent.0', :target_type => 'virtio'
    v.channel :type => 'spicevmc', :target_name => 'com.redhat.spice.0', :target_type => 'virtio'
    override.vm.synced_folder './', '/vagrant', type: "rsync"
  end

  # VirtualBox specific stuff
  config.vm.provider "virtualbox" do |v, override|
    override.vm.box = "debian/contrib-buster64"
    override.vagrant.plugins = "vagrant-vbguest"

    # Display the VirtualBox GUI when booting the machine
    v.gui = true

    v.cpus   = VM_CPUS
    v.memory = VM_MEMORY

    v.customize ["modifyvm", :id, "--vram", VM_VRAM]
    v.customize ["modifyvm", :id, "--accelerate3d", "on"]
    v.customize ["modifyvm", :id, "--nictype1", "virtio"]
    v.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--device", "0", "--port", "0", "--nonrotational", "on", "--discard", "on"]
    # timesync equivalent to 2.5 minutes in ms)
    v.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", "150000"]
  end

  # Use vagrant's default insecure key
  config.ssh.insert_key = false

  config.vm.provision "ansible" do |ansible|
   ansible.playbook = "ansible/site.yml"
   ansible.galaxy_command = "ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
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
