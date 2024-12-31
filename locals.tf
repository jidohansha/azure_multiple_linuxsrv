# resource configuration blocks.

resource "azurerm_virtual_network" "vnet" {
  name                = "mlops-srv-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "centralus"
  resource_group_name = "silo_rg"
}

resource "azurerm_virtual_machine" "multiple-srv" {
  count                 = 5
  name                  = "mlopsanalytics-${count.index}"
  location              = "CentralUS"
  resource_group_name   = "Silo_rg"
  network_interface_ids = [azurerm_network_interface.mlops_data_analytics[count.index].id]
  vm_size               = "Standard_B1ls"

  storage_os_disk {
    name              = "osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname-${count.index}"
    admin_username = "tomiadmin"
    admin_password = "Refle#19777@@"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "mlopsdataanalytics"
  }
}

resource "azurerm_network_interface" "mlops_data_analytics" {
  count              = 5  
  name                = "mlops_data_analytics-${count.index}"
  location            = "CentralUS"
  resource_group_name = "silo_rg"

  ip_configuration {
    name                          = "ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = "silo_rg"
  virtual_network_name = "mlops-srv-vnet"
  address_prefixes     = ["10.0.0.0/24"]
}
