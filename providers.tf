terraform {
  backend "azurerm" {}
}

terraform {
  required_version = ">= 0.15.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.62.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.3.1"
    }

  }
}

provider "azurerm" {
      features {}
}


provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}



provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host
    client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
  }
}
