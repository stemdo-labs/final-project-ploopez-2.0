//Nombre del grupo de recursos
variable "resource_group_name" {
  description = "Nombre del Resource Group existente en Azure"
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "The resource group name must not be empty."
  }
}

//Nombre de la red virtual 
variable "vnet_name" {

  description = "Nombre de la VNet"
  type        = string
}

// Espacio de direcciones de la red virtual
variable "vnet_address_space" {
  description = "Espacio de direcciones de la Virtual Network"
  type        = list(string)
  validation {
    condition     = can(cidrsubnet(element(var.vnet_address_space, 0), 0, 0))
    error_message = "The VNet address space must be a valid CIDR block."
  }
}

variable "location" {
  description = "Ubicación donde se desplegará la VNet"
  default     = "UK South"
}



# Network Interface
variable "network_interface" {
  description = "The network interface configuration"
  type = map(object({
    subnet               = string
    ip_configuration = object({
      name                          = string
      private_ip_address_allocation = string
      public_ip_address_id          = optional(string)
    })
  }))
}




# Máquinas virtuales Linux
variable "linux_virtual_machine" {
    description = "Máquinas virtuales Linux"
    type        = map(object({
        computer_name       = string
        name                = string
        resource_group_name = string
        location            = string
        size                = string
        admin_username      = string
        admin_password      = string
        os_disk = object({
            caching              = string
            storage_account_type = string
        })
        source_image_reference = object({
            publisher = string
            offer     = string
            sku       = string
            version   = string
        })
    }))
  
}


variable "network_security_groups" {
  description = "Configuración de los Network Security Groups"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    security_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}


# Azure Container Registry
variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
}