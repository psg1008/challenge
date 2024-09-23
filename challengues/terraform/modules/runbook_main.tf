resource "azurerm_automation_runbook" "remove_cyberarklicenses" {
  name                    = "replicate_aks_cluster"
  location                = "West Europe"
  resource_group_name     = "rg-test-aks"
  automation_account_name = "test_aks_cluster_automation_account"
  log_verbose             = "true"
  log_progress            = "true"
  runbook_type            = "PowerShell"

  description = "This copies all the charts from the reference registry"

  content = templatefile("./script/automate_cluster_copy.ps1")
}
