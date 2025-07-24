resource "null_resource" "provision_ubuntu" {
  depends_on = [vagrant_vm.ubuntu-terraform]

  provisioner "local-exec" {

    command = "vagrant ssh ubuntu-terraform -c 'bash /home/vagrant/provision/install-static-site.sh'"

  }
}
