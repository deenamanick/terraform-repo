terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "4.1.0"
    }
  }
}

provider "vagrant" {}

resource "vagrant_vm" "ubuntu-terraform" {
  # Terraform uses the Vagrantfile in this directory
  vagrantfile_dir = "."
  get_ports       = true # If using forwarded ports
}