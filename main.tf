resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "${random_pet.prefix.id}boxboatsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "example" {
  name                         = "boxboat-demo-sql"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.administrator_username
  administrator_login_password = random_password.password.result
}

resource "azurerm_mssql_database" "test" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.example.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 5
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

resource "random_pet" "prefix" {
  length = 1
}