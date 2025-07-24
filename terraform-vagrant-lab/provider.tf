terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "4.1.0"
    }
  }
}

provider "vagrant" {}

resource "vagrant_vm" "k8s_machines" {
  # Terraform uses the Vagrantfile in this directory
  vagrantfile_dir = "."
  get_ports       = true # If using forwarded ports
}