Absolutely! Here's the **step-by-step guide for Windows systems** to run the same **Terraform + Vagrant + VirtualBox Kubernetes Lab** — fully offline and ready for classroom use. This works on **Windows 10/11** using:

* **Terraform (native executable)**
* **Vagrant + VirtualBox**
* **PowerShell** or **Git Bash** (for script execution)

---

## 🎯 **Goal**

Create a local Kubernetes lab on Windows using:

* 🧱 VMs defined in `Vagrantfile`
* 📦 Terraform to manage VMs and provisioning
* 🐳 Kubernetes tools installed via script
* ✅ Fully local (no cloud needed)

---

# 🧰 Part 1: Prerequisites (Windows)

Install the following on each Windows machine:

| Tool                             | Download Link                                                                                              |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| **Terraform**                    | [https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads) |
| **Vagrant**                      | [https://developer.hashicorp.com/vagrant/downloads](https://developer.hashicorp.com/vagrant/downloads)     |
| **VirtualBox**                   | [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)                     |
| **Git for Windows** *(optional)* | [https://gitforwindows.org/](https://gitforwindows.org/)                                                   |

✅ **Check installation** (PowerShell or Git Bash):

```bash
terraform -version
vagrant --version
VBoxManage --version
```

---

# 📁 Part 2: Folder Structure

```
terraform-vagrant-k8s-lab/
├── main.tf
├── Vagrantfile
├── provision/
│   └── install-k8s.ps1
```

---

# ⬇️ Part 3: Install the Provider Manually

### 📦 1. Download the provider binary:

```powershell
Invoke-WebRequest -Uri "https://github.com/bmatcuk/terraform-provider-vagrant/releases/download/v4.1.0/terraform-provider-vagrant_4.1.0_windows_amd64.zip" -OutFile "terraform-provider-vagrant.zip"
Expand-Archive terraform-provider-vagrant.zip -DestinationPath .

```
### For linux

```
wget https://github.com/bmatcuk/terraform-provider-vagrant/releases/download/v0.4.0/terraform-provider-vagrant_0.4.0_linux_amd64.zip

unzip terraform-provider-vagrant_0.4.0_linux_amd64.zip
mkdir -p ~/.terraform.d/plugins/registry.terraform.io/bmatcuk/vagrant/0.4.0/linux_amd64/
mv terraform-provider-vagrant ~/.terraform.d/plugins/registry.terraform.io/bmatcuk/vagrant/0.4.0/linux_amd64/terraform-provider-vagrant
chmod +x ~/.terraform.d/plugins/registry.terraform.io/bmatcuk/vagrant/0.4.0/linux_amd64/terraform-provider-vagrant
```

---

### 🗂 2. Move provider to Terraform plugin path:

```powershell
$pluginDir = "$env:APPDATA\terraform.d\plugins\registry.terraform.io\bmatcuk\vagrant\4.1.0\windows_amd64"
New-Item -ItemType Directory -Force -Path $pluginDir
Move-Item terraform-provider-vagrant.exe "$pluginDir\terraform-provider-vagrant.exe"
```

---

# 📄 Part 4: Create the Configuration Files

---

## ✅ `main.tf`

```hcl
terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "4.1.0"
    }
  }
}

provider "vagrant" {}

resource "vagrant_vm" "k8s_vms" {
  vagrantfile_dir = "."
  get_ports       = true
}

resource "null_resource" "provision_master" {
  depends_on = [vagrant_vm.k8s_vms]

  provisioner "local-exec" {
    command = "vagrant ssh k8s-master -c 'bash /vagrant/provision/install-k8s.sh'"
  }
}

resource "null_resource" "provision_worker1" {
  depends_on = [vagrant_vm.k8s_vms]

  provisioner "local-exec" {
    command = "vagrant ssh k8s-worker1 -c 'bash /vagrant/provision/install-k8s.sh'"
  }
}

```

---

## ✅ `Vagrantfile`

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"

  config.vm.define "k8s-master" do |master|
    master.vm.hostname = "k8s-master"
    master.vm.network "private_network", ip: "192.168.56.10"
  end

  config.vm.define "k8s-worker1" do |worker|
    worker.vm.hostname = "k8s-worker1"
    worker.vm.network "private_network", ip: "192.168.56.11"
  end
end
```

---

## ✅ `provision/install-k8s.ps1`

This script installs Docker and Kubernetes on Ubuntu VMs:

```powershell
#!/usr/bin/env pwsh
sudo apt-get update
sudo apt-get install -y docker.io apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable docker
sudo systemctl start docker
```

> ✅ Save this file using **Unix line endings (LF)** — Git Bash or VS Code can do this.

---

# ▶️ Part 5: Run the Lab

### Initialize Terraform:

```bash
terraform init
```

### Start the lab:

```bash
terraform apply
```

This will:

* Bring up both VMs
* Run the provisioning script via `vagrant ssh`
* Install Kubernetes packages

---


# 🧹 Part 7: Destroy When Done

```bash
terraform destroy
```
---

## ✅ Summary

| ✅ Component          | 🪟 Windows Notes                           |
| -------------------- | ------------------------------------------ |
| VirtualBox + Vagrant | Runs the actual Ubuntu VMs                 |
| Terraform            | Controls the whole lab setup               |
| Plugin setup         | Manual install in `%APPDATA%`              |
| Provisioning         | Via PowerShell `.ps1` scripts in Ubuntu    |
| Offline use          | Possible once box + provider is downloaded |

---


