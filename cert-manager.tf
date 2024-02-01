module "cert_manager" {
  depends_on   = [kubernetes_namespace.namespace]
  source = "github.com/sculley/terraform-kubernetes-cert-manager"
  replica_count = 2
}

resource "helm_release" "issuer" {
  name         = "issuer"
  chart        = "./issuer"
  depends_on   = [module.cert_manager]
  force_update = true
  namespace    = var.pod_namespace

}

resource "helm_release" "cert" {
  name         = "cert"
  chart        = "./cert"
  depends_on   = [module.cert_manager]
  force_update = true
  namespace    = var.pod_namespace

  set {
    name = "stateChecksum"
    value = filemd5("${path.module}/cert/templates/certificate.yaml") 
  }

  set {
    name = "valueChecksum"
    value = filemd5("${path.module}/cert/values.yaml") 
  }


  values = [templatefile("${path.module}/cert/values.yaml", { calc = var.calc,
    glowapi = var.glowapi, loanapi = var.loanapi, paymentui = var.paymentui,
  loanui = var.loanui, glowui = var.glowui, demo_back = var.demo_back, demo_ui = var.demo_ui, env_domain = var.env_domain })]

}
