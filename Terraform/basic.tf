# Create the Azure VPN GW resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.rg_name}"
  location = "${var.rg_location}"
}

# Create a virtual network within the VPN GW resource group
resource "azurerm_virtual_network" "main" {
  name                = "terraformvnet"
  address_space       = ["${var.ressource_address_space}"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

# Create the default subnet 
resource "azurerm_subnet" "defaultsubnet" {
  name                 = "default"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${var.default_subnet}"
}

# Create the Gateway Subnet
resource "azurerm_subnet" "azuregwsubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${var.gw_subnet}"
}

# Create a front Subnet
resource "azurerm_subnet" "azurefrontsubnet" {
  name                 = "frontSubnet"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${var.front_subnet}"
}

# Create a data Subnet
resource "azurerm_subnet" "azuredatasubnet" {
  name                 = "dataSubnet"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${var.data_subnet}"
}

#VM network interface
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
 ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.azuredatasubnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

#la VM
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "patrick"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys = {
      path = "/home/patrick/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }
  tags {
    environment = "test"
  }
}
