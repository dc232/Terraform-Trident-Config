resource "azurerm_netapp_account" "netapp" {
  name                = "netapp-netappaccount"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_netapp_pool" "netapp" {
  name                = "netapp-netapppool"
  location            = var.location
  resource_group_name = var.resource_group_name
  account_name        = azurerm_netapp_account.netapp.name
  service_level       = var.servicelevel
  size_in_tb          = 4
}


resource "kubernetes_namespace" "netapp" {
  metadata {
    name = var.namespace
  }
}

data "template_file" "crds" {
  url = "https://raw.githubusercontent.com/NetApp/trident/master/helm/trident-operator/crds/tridentorchestrators.yaml"
}

resource "kubectl_manifest" "deploy_trident_orchestrator_crd" {
    yaml_body = data.http.crds.response_body
}

resource "helm_release" "netapphelm" {
    depends_on = [
      kubernetes_namespace.netapp,
      kubectl_manifest.deploy_trident_orchestrator_crd
    ]
    name  = "netapp-trident-operator"
    namespace = kubernetes_namespace.netapp.metadata[0].name
    repository = "https://netapp.github.io/trident-helm-chart"
    chart = "trident-operator"
#setting debug options for now for exra telemetry
  set {
    name = "tridentDebug"
    value = true
  }

  set {
    name = "operatorDebug"
    value = true
  }

}

resource "kubernetes_secret_v1" "netapp" {
  metadata {
    name = "netapp-backned-secret"
    namespace = kubernetes_namespace.netapp.metadata[0].name
  }

  data = {
   clientID = azuread_application.test.application_id
   clientSecret = azuread_service_principal_password.test.value
  }
}


data "template_file" "netapp_backend_config"{
    depends_on = [kubernetes_secret_v1.netapp]
  template = file("${path.module}/BackendCRD/backend-anf.yaml")
  vars = {
      # "clientID" = data.azurerm_client_config.current.client_id
      # "clientSecret" = var.netappclientsecret
      "metadataname" =  "nett-app-backend"
      "namespace" = kubernetes_namespace.netapp.metadata[0].name                     
      "storagedrivername" = "azure-netapp-files"   
      "subscriptionid" = data.azurerm_client_config.current.subscription_id
      "tenantid" = data.azurerm_client_config.current.tenant_id
      "location" = var.location
      "servicelevel" = var.servicelevel
      "secretcredentails" = kubernetes_secret_v1.netapp.metadata[0].name
      "subnet" = azurerm_subnet.netapp.name
      "virtualNetwork" = var.virtual_network_name
      "backendName" = azurerm_netapp_pool.netapp.name
      "defaultvolumesize" = var.persistence_size
      "volumesizelimit" = var.max_persistence_size
    }
}

resource "kubectl_manifest" "netapp_production_backend_config" {
    yaml_body = data.template_file.netapp_backend_config.rendered
    depends_on =[
      data.template_file.netapp_backend_config,
      kubernetes_secret_v1.netapp
    ]
}