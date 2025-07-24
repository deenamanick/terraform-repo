resource "null_resource" "provision_master" {
  depends_on = [vagrant_vm.k8s_machines]

  provisioner "local-exec" {
    #     command = <<EOT
    #       vagrant ssh k8s-master -c "sudo apt update && sudo apt install -y docker.io kubeadm kubelet kubectl"
    #     EOT
    command = "vagrant ssh k8s-master -c 'bash /home/vagrant/provision/install-k8s.sh'"

  }
}

resource "null_resource" "provision_worker1" {
  depends_on = [vagrant_vm.k8s_machines]

  provisioner "local-exec" {
    # command = <<EOT
    #   vagrant ssh k8s-worker1 -c "sudo apt update && sudo apt install -y docker.io kubeadm kubelet kubectl"
    # EOT
    command = "vagrant ssh k8s-master -c 'bash /home/vagrant/provision/install-k8s.sh'"
  }
}
