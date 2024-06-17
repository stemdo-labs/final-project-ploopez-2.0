resource_group_name = "rg-plopez-dvfinlab"
vnet_name = "vnetplopeztfexercise01"
vnet_address_space = ["10.0.0.0/16"]
location = "West Europe"
acr_name = "acrplopez"


subnets = {
  "subnet1" = {
    name                 = "subnet1"
    resource_group_name  = "rg-plopez-dvfinlab"
    virtual_network_name = "vnetplopeztfexercise01"
    address_prefixes     = ["10.0.1.0/24"]
  }
  "subnet2" = {
    name                 = "subnet2"
    resource_group_name  = "rg-plopez-dvfinlab"
    virtual_network_name = "vnetplopeztfexercise01"
    address_prefixes     = ["10.0.2.0/24"]
  }
}


network_interface = {
  "linux_vm1" = {
    subnet = "subnet1"
    ip_configuration = {
      name                          = "ipconfig1"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = null
    }
  },
  "linux_vm2" = {
    subnet = "subnet2"
    ip_configuration = {
      name                          = "ipconfig2"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = null
    }
  }
}



linux_virtual_machine = {
  "linux_vm1" = {
    computer_name       = "Linux1"
    name                = "linux_vm1"
    resource_group_name = "rg-plopez-dvfinlab"
    location            = "West Europe"
    size                = "Standard_B1ms"
    admin_username      = "adminuser"
    admin_password      = "A1b#c2"
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  },
    "linux_vm2" = {
        computer_name       = "Linux2"
        name                = "linux_vm2"
        resource_group_name = "rg-plopez-dvfinlab"
        location            = "West Europe"
        size                = "Standard_B1ms"
        admin_username      = "adminuser"
        admin_password      = "A1b#c2"
        os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
        }
        source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
        }
    }
}


network_security_groups = {
  nsg1 = {
    name                = "NSG1"
    location            = "West Europe"
    resource_group_name = "rg-plopez-dvfinlab"
    security_rules = [
      {
        name                       = "allowSSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "allowHTTP"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
      name                       = "allowMySQL"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3306"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      }
    ]
  },
  nsg2 = {
    name                = "NSG2"
    location            = "West Europe"
    resource_group_name = "rg-plopez-dvfinlab"
    security_rules = [
      {
        name                       = "allowSSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "allowHTTP"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}


# Valores del aks cluster

aks_cluster_name    = "aks-cluster-plopez"
node_count          = 1
node_vm_size        = "Standard_B2s"