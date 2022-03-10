
#azureeeeeeeeeeeeeeeeeeeee
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.98.0"
    }

  }
}
#configure the azure provider
provider "azurerm" {
  features {}

}
#creating a resource group 1 with variable from dev
resource "azurerm_resource_group" "nishant01" {
  name     = var.name_from_dev
  location = "east us"

}
#creating a resource group 2 with variable from qa
resource "azurerm_resource_group" "nishant02" {
  name     = var.name_from_qa
  location = "central india"

}
#app service plan
resource "azurerm_app_service_plan" "nishantappserviceplan" {
  name                = var.name_from_dev
  location            = azurerm_resource_group.nishant01.location
  resource_group_name = azurerm_resource_group.nishant01.name

  sku {
    tier = "standard"
    size = "s1"
  }

}
#app service
resource "azurerm_app_service" "nishantappservice" {
  name                = var.name_from_dev
  location            = azurerm_resource_group.nishant01.location
  resource_group_name = azurerm_resource_group.nishant01.name
  app_service_plan_id = azurerm_app_service_plan.nishantappserviceplan.id


}
#storage account
resource "azurerm_storage_account" "nishantstorageaccount" {
  name=var.name_from_dev
  location=azurerm_resource_group.nishant01.location
  resource_group_name = azurerm_resource_group.nishant01.name
  account_tier = "standard"
  account_replication_type = "GRS"
}
