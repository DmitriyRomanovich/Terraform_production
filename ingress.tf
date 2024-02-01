resource "helm_release" "nginx_ingress" {
  name       = "nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace = kubernetes_namespace.ingress.metadata[0].name
  version = "3.29.0"

  cleanup_on_fail = true


  set {
    name  = "controller.service.spec.externalTrafficPolicy"
    value = "Local"
  }


  set {
    name  = "controller.config.use-forwarded-headers"
    value = "true"
  }


  set {
    name  = "controller.config.enable-modsecurity"
    value = "true"
  }

  set {
    name  = "controller.config.enable-owasp-modsecurity-crs"
    value = "true"
  }


  set {
    name  = "controller.config.server-tokens"
    value = "False"
  }

 
}

resource "helm_release" "ingress_config" {
  name              = "ingressconfig"
  namespace         = var.pod_namespace
  depends_on        = [module.cert_manager]
  chart             = "./ingress_config/ingress"
  force_update      = true
  
  set {
    name = "stateChecksum"
    value = filemd5("${path.module}/ingress_config/ingress/templates/glow.yaml") 
  }
  
  set {
    name = "stateChecksum2"
    value = filemd5("${path.module}/ingress_config/ingress/templates/calc.yaml") 
  }

  set {
    name = "stateChecksum3"
    value = filemd5("${path.module}/ingress_config/ingress/templates/demo.yaml") 
  }

  set {
    name = "stateChecksum4"
    value = filemd5("${path.module}/ingress_config/ingress/templates/loan.yaml") 
  }


  set {
    name = "valueChecksum"
    value = filemd5("${path.module}/ingress_config/ingress/values.yaml") 
  }


  values = [templatefile("${path.module}/ingress_config/ingress/values.yaml", { calc = var.calc,
    glowapi = var.glowapi, loanapi = var.loanapi, paymentui = var.paymentui,
  loanui = var.loanui, glowui = var.glowui, demo_back = var.demo_back, demo_ui = var.demo_ui, env_domain = var.env_domain })]


}
