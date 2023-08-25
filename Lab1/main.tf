provider "azurerm" {
    features {
      
    }
  
}
resource "azurerm_resource_group" "rg10" {
    name = "resourcegroup1"
    location = "eastus"
    
  
}