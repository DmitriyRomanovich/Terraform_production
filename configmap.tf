resource "helm_release" "configmap" {
  name         = "configmap"
  depends_on   = [kubernetes_namespace.namespace]
  chart        = "./configmaps"
  force_update = true
  namespace    = var.pod_namespace

  set {
    name = "stateChecksum"
    value = filemd5("${path.module}/configmaps/templates/configmap.yaml") 
  }

  set {
    name = "valueChecksum"
    value = filemd5("${path.module}/configmaps/values.yaml") 
  }

  values = [templatefile("${path.module}/configmaps/values.yaml", { env_domain = var.env_domain, inauth_enable = var.inauth_enable, inauth_domain = var.inauth_domain, inauth_apikey = var.inauth_apikey })]

}