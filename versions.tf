terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.22.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.13.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.5.1"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}