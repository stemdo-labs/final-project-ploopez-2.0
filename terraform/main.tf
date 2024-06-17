terraform {
  required_version = ">= 1.5.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-plopez-dvfinlab"
    storage_account_name = "staplopezdvfinlab"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
 
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
}


# Create subnets
resource "azurerm_subnet" "subnets" {
  depends_on = [azurerm_virtual_network.vnet]
  for_each = var.subnets
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  
}

# Create public IP
# resource "azurerm_public_ip" "terraform_public_ip_1" {
#   name                = "public-ip1"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
# }

resource "azurerm_public_ip" "terraform_public_ip_2" {
  name                = "public-ip2" 
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static" 
}

# Create Network Interface
resource "azurerm_network_interface" "netint1" {
  //for_each = var.network_interface
  name                = "netint1"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnets["subnet1"].id
    private_ip_address_allocation = "Dynamic"
    //public_ip_address_id          = azurerm_public_ip.terraform_public_ip_1.id
  }
}

resource "azurerm_network_interface" "netint2" {
  name                = "netint2" 
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig2"
    subnet_id                     = azurerm_subnet.subnets["subnet2"].id 
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terraform_public_ip_2.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "netint1" {
  network_interface_id    = azurerm_network_interface.netint1.id
  network_security_group_id = azurerm_network_security_group.nsg["nsg1"].id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "netint2" {
  network_interface_id    = azurerm_network_interface.netint2.id
  network_security_group_id = azurerm_network_security_group.nsg["nsg2"].id
}

# Create Linux Virtual Machines
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

# Install Ansible on the first Linux VM  con un trigger
resource "null_resource" "install_ansible" {
  triggers = {
    linux_vm2_id = azurerm_linux_virtual_machine.linux_virtual_machine["linux_vm2"].id
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/adminuser/.ssh",
      "sudo apt update",
      "sudo apt install ansible -y",
      "sudo apt install sshpass -y",
      "if [ ! -f /home/adminuser/.ssh/id_rsa ]; then ssh-keygen -t rsa -f /home/adminuser/.ssh/id_rsa -N '' -q; fi",
      #"ssh-copy-id adminuser@direccion_ip_destino"
      "export VM1_IP=${azurerm_network_interface.netint1.private_ip_address}",
      "sshpass -p '${var.linux_virtual_machine["linux_vm1"].admin_password}' ssh-copy-id -o StrictHostKeyChecking=no -i /home/adminuser/.ssh/id_rsa.pub ${var.linux_virtual_machine["linux_vm1"].admin_username}@${azurerm_network_interface.netint1.private_ip_address}",

      #------------------#
      # Descargar archivos de ansible 
      # "wget https://raw.githubusercontent.com/stemdo-labs/final-project-ploopez/main/ansible/inventario -O /home/adminuser/inventario",
      # "wget https://raw.githubusercontent.com/stemdo-labs/final-project-ploopez/main/ansible/playbook.yaml -O /home/adminuser/playbook.yaml",
      # "wget https://raw.githubusercontent.com/stemdo-labs/final-project-ploopez/main/ansible/vars.yaml -O /home/adminuser/vars.yaml",
      #------------------#

      # "echo 'Sustituyendo  public_ip_vm1  por '\"$VM1_IP\"' en /home/adminuser/inventario'",
      # # Modificar archivo de inventario para agregar la IP privada de la VM1
      # "sed -i 's/public_ip_vm1/$VM1_IP/g' /home/adminuser/inventario",
      # # Ejecutar Ansible playbook
      # "ansible-playbook -i /home/adminuser/inventario /home/adminuser/playbook.yaml"
    ]

    connection {
      type     = "ssh"
      user     = var.linux_virtual_machine["linux_vm2"].admin_username
      password = var.linux_virtual_machine["linux_vm2"].admin_password
      host     = azurerm_public_ip.terraform_public_ip_2.ip_address
    }
  }
}

# Crear Network Security Group y sus reglas de seguridad
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

## AKS Cluster ##

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks"
  sku_tier           = "Standard"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    vnet_subnet_id = azurerm_subnet.subnets["subnet1"].id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr = "10.0.3.0/24"
    dns_service_ip = "10.0.3.10"
  }
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled            = true

}
