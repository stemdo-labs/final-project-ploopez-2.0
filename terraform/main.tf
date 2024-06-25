terraform {
  required_version = ">= 1.5.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }

  }

  backend "azurerm" {
    resource_group_name  = "rg-plopez-fp2"
    storage_account_name = "staplopezfp2"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
 
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

# Fetch an existing virtual network
data "azurerm_virtual_network" "vnet-common-bootcamp" {
  name                = "vnet-common-bootcamp"
  resource_group_name = "final-project-common"
}

# Fetch an existing subnet within the virtual network
data "azurerm_subnet" "sn-plopez" {
  name                 = "sn-plopez"
  virtual_network_name = "vnet-common-bootcamp"
  resource_group_name  = "final-project-common"
}

# Fetch an existing Azure Kubernetes Service cluster
data "azurerm_kubernetes_cluster" "aks" {
  name                = "aksbootcampwe01"
  resource_group_name = "final-project-common"
}

resource "azurerm_public_ip" "terraform_public_ip_2" {
  name                = "public-ip2" 
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static" 
}

resource "azurerm_network_interface" "netint1" {

  name                = "netint1"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.azurerm_subnet.sn-plopez.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "netint2" {
  name                = "netint2" 
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig2"
    subnet_id                     = data.azurerm_subnet.sn-plopez.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terraform_public_ip_2.id
  }
}

resource "azurerm_network_interface_security_group_association" "netint1" {
  network_interface_id    = azurerm_network_interface.netint1.id
  network_security_group_id = azurerm_network_security_group.nsg["nsg1"].id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "netint2" {
  network_interface_id    = azurerm_network_interface.netint2.id
  network_security_group_id = azurerm_network_security_group.nsg["nsg2"].id
}


resource "azurerm_network_security_group" "nsg" {
  for_each            = var.network_security_groups
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name


  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  for_each = var.linux_virtual_machine

  computer_name                  = each.value.computer_name
  name                           = each.value.name
  resource_group_name            = each.value.resource_group_name
  location                       = each.value.location  
  size                           = each.value.size
  admin_username                 = each.value.admin_username
  admin_password                 = each.value.admin_password
  disable_password_authentication = false

  # Ajuste en la asignación de network_interface_ids para que sea más flexible y no dependa de una comparación directa de claves.
  network_interface_ids          = [lookup(local.network_interface_map, each.key, null)]

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }
}

locals {
  network_interface_map = {
    "linux_vm1" = azurerm_network_interface.netint1.id
    "linux_vm2" = azurerm_network_interface.netint2.id
  }
}

resource "null_resource" "install_ansible" {
  triggers = {
    linux_vm2_id = azurerm_linux_virtual_machine.linux_virtual_machine["linux_vm2"].id
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/adminuser/.ssh",
      "sudo apt update",
      "sudo apt-get install -y mysql-client",
      "sudo apt install ansible -y",
      "sudo apt install sshpass -y",
      "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
  
      "if [ ! -f /home/adminuser/.ssh/id_rsa ]; then ssh-keygen -t rsa -f /home/adminuser/.ssh/id_rsa -N '' -q; fi",
      "export VM1_IP=${azurerm_network_interface.netint1.private_ip_address}",
      "sshpass -p '${var.linux_virtual_machine["linux_vm1"].admin_password}' ssh-copy-id -o StrictHostKeyChecking=no -i /home/adminuser/.ssh/id_rsa.pub ${var.linux_virtual_machine["linux_vm1"].admin_username}@${azurerm_network_interface.netint1.private_ip_address}"
    ]

    connection {
      type     = "ssh"
      user     = var.linux_virtual_machine["linux_vm2"].admin_username
      password = var.linux_virtual_machine["linux_vm2"].admin_password
      host     = azurerm_public_ip.terraform_public_ip_2.ip_address
    }
  }
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled            = true

}
