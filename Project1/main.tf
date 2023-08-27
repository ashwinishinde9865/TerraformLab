provider "azurerm" {

  features {

  }
}
resource "azurerm_resource_group" "RG1" {
  name     = "newRG"
  location = "eastus"

}

resource "azurerm_virtual_network" "vnet" {
  name                = "newvNet"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  address_space       = ["10.0.0.0/16"]

  dns_servers = ["10.0.0.4", "10.0.0.5"]

  depends_on = [azurerm_resource_group.RG1]

}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [azurerm_resource_group.RG1, azurerm_virtual_network.vnet]

}
resource "azurerm_network_interface" "NIC" {
  name                = "NIC1"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}
resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "vm1"
  resource_group_name   = azurerm_resource_group.RG1.name
  location              = azurerm_resource_group.RG1.location
  size                  = "standard_B2s"
  admin_username        = "admin100"
  admin_password        = "Welcome@12345"
  network_interface_ids = [azurerm_network_interface.NIC.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

}