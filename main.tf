# Configure the Azure provider
provider "azurerm" {
  features {
  }

  subscription_id = var.subscription_id
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "eastus" # You can change the location as needed
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "myVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a network security group with port 22 open
resource "azurerm_network_security_group" "nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# Define the SSH key variable
variable "subscription_id" {
  description = "Account subscription"
  type        = string
}

# Define the SSH key variable
variable "vm_public_key" {
  description = "The SSH public key for the VMs"
  type        = string
}

# Define the users variable
variable "users" {
  description = "A map of user configurations"
  type = map(object({
    vm_name = string
  }))
  default = {
    "user1" = {
      vm_name = "user1-vm"
    }
  }
}

# Create a public IP per user
resource "azurerm_public_ip" "public_ip" {
  for_each            = var.users
  name                = "${each.value.vm_name}-publicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Create a network interface per user
resource "azurerm_network_interface" "nic" {
  for_each            = var.users
  name                = "${each.value.vm_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${each.value.vm_name}-nicConfiguration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[each.key].id
  }
}

# Associate the NIC with the NSG
resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  for_each                  = var.users
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create the virtual machine per user
resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.users
  name                = each.value.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s" # Updated SKU to Standard
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.vm_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

# Output the public IP addresses
output "public_ip_addresses" {
  description = "Public IP addresses of the VMs"
  value       = { for k, ip in azurerm_public_ip.public_ip : k => ip.ip_address }
}
