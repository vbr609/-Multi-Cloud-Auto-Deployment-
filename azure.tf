terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" # Use the latest stable version (e.g., 3.93.0 or similar)
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "my_rg" {
  name     = "MyResourceGroup"
  location = "West Europe"
}

# Terraform Backend Configuration
terraform {
  backend "azurerm" {
    resource_group_name   = "automating-stuff-rg"
    storage_account_name  = "automatingstuffsairaj"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "my_vnet" {
  name                = "myVnet"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "my_subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Security Group
resource "azurerm_network_security_group" "my_nsg" {
  name                = "Sairaj-nsg"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  security_rule {
    name                       = "allowanyinboundssh"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allowinboundapp"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# NSG Association to Subnet
resource "azurerm_subnet_network_security_group_association" "nsg2subnet" {
  subnet_id                 = azurerm_subnet.my_subnet.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id

  depends_on = [ 
    azurerm_virtual_network.my_vnet, 
    azurerm_subnet.my_subnet 
  ]
}

# Public IPs
resource "azurerm_public_ip" "my_public_ip" {
  count               = 2
  name                = "myPublicIP-${count.index + 1}"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  allocation_method   = "Static"
}

# Network Interfaces
resource "azurerm_network_interface" "my_nic" {
  count               = 2
  name                = "myNIC-${count.index + 1}"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  ip_configuration {
    name                          = "myNICConfig"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip[count.index].id
  }
}

# Linux Virtual Machines
resource "azurerm_linux_virtual_machine" "my_vms" {
  count               = 2
  name                = "myLinuxVM-${count.index + 1}"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  network_interface_ids = [azurerm_network_interface.my_nic[count.index].id]
  admin_username      = "adminuser"
  size                = "Standard_B1s"

  admin_ssh_key {
    username   = "adminuser"
    public_key = local.public_key_content
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  depends_on = [
    azurerm_virtual_network.my_vnet,
    azurerm_subnet.my_subnet,
    azurerm_network_interface.my_nic
  ]
}


# Output the public IPs of the Azure VMs
output "azure_vm_public_ips" {
  value = azurerm_public_ip.my_public_ip[*].ip_address
}
