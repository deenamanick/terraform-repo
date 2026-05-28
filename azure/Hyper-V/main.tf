# Configure the Azure provider
provider "azurerm" {
  features {}

  subscription_id                 = "4f6a6eb9-27d0-4ed6-a31c-2bde135e2db6"
  resource_provider_registrations = "none"
}



# Reference the existing resource group
data "azurerm_resource_group" "my_rg" {
  name = "rg_sb_eastus_227684_1_175350299343"
}

# Create a virtual network in the existing resource group
resource "azurerm_virtual_network" "win2022_vnet" {
  name                = "win2022-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.my_rg.location
  resource_group_name = data.azurerm_resource_group.my_rg.name
}

# Create a subnet in the existing VNet
resource "azurerm_subnet" "win2022_subnet" {
  name                 = "win2022-subnet"
  resource_group_name  = data.azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.win2022_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP with Standard SKU
resource "azurerm_public_ip" "win2022_pip" {
  name                = "win2022-pip"
  location            = data.azurerm_resource_group.my_rg.location
  resource_group_name = data.azurerm_resource_group.my_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create a network security group with basic RDP rule
resource "azurerm_network_security_group" "win2022_nsg" {
  name                = "win2022-nsg"
  location            = data.azurerm_resource_group.my_rg.location
  resource_group_name = data.azurerm_resource_group.my_rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "win2022_nic" {
  name                = "win2022-nic"
  location            = data.azurerm_resource_group.my_rg.location
  resource_group_name = data.azurerm_resource_group.my_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.win2022_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.win2022_pip.id
  }
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.win2022_nic.id
  network_security_group_id = azurerm_network_security_group.win2022_nsg.id
}

# Create the Windows VM
resource "azurerm_windows_virtual_machine" "win2022_vm" {
  name                = "win2022-vm"
  resource_group_name = data.azurerm_resource_group.my_rg.name
  location            = data.azurerm_resource_group.my_rg.location
  size                = "Standard_D8s_v3"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!" # Change to a secure password
  network_interface_ids = [
    azurerm_network_interface.win2022_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }

  tags = {
    auto-shutdown = "true"
    shutdown-time = "02:00"
  }
}

output "vm_public_ip" {
  value = azurerm_public_ip.win2022_pip.ip_address
}

output "admin_username" {
  value = azurerm_windows_virtual_machine.win2022_vm.admin_username
}