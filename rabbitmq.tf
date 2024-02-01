resource "helm_release" "rabbitmq" {
  name                = "rabbitmq"
  version             = "8.9.2"
  namespace           = var.pod_namespace
  depends_on          = [kubernetes_namespace.namespace]
  repository          = "https://charts.bitnami.com/bitnami"
  chart               = "rabbitmq"
  repository_username = "agent"
  repository_password = "agent"

  set {
    name  = "auth.username"
    value = "agent"
  }

  set {
    name  = "auth.password"
    value = "agent"
  }

  set {
    name  = "auth.erlangCookie"
    value = "agent"
  }

}