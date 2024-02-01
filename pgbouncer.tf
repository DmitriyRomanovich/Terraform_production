### Generate pgbouncer.ini config for Pgbouncer
resource "local_file" "pgbouncer_ini" {
  filename = "pgbouncer_secret/pgbouncer.ini"
  content  = <<-EOT
[databases]
* = host=${var.db_ip} port=${var.db_port}
[pgbouncer]
# Do not change these settings:
listen_addr = 0.0.0.0
auth_file = /etc/pgbouncer/userlist.txt
auth_type = trust
server_tls_sslmode = verify-ca
server_tls_ca_file = /etc/root.crt.pem
listen_port = ${var.db_port}
unix_socket_dir =
user = postgres
pool_mode = transaction
max_client_conn = 5000
ignore_startup_parameters = extra_float_digits
admin_users = postgres
  EOT
}

### Generate userlist.txt for Pgbouncer
resource "local_file" "pgbouncer_userlist_txt" {
  filename = "pgbouncer_secret/userlist.txt"
  content  = <<-EOT
"${var.db_user}" "${var.db_password}"
  EOT
}

### Get credentials for AKS
resource "null_resource" "creds_aks" {
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${var.resource_group_name} --name ${var.cluster_name} --overwrite-existing"
  }
}

### Delete secret for Pgbouncer if it exists in AKS
resource "null_resource" "secret_delete" {
  provisioner "local-exec" {
    command = "kubectl delete secret azure-pgbouncer-config -n ${var.pod_namespace} --ignore-not-found"
  }
  depends_on = [null_resource.creds_aks]
}

### Generate secret for Pgbouncer in AKS
resource "null_resource" "secret_create" {
  provisioner "local-exec" {
    command = "kubectl create secret generic azure-pgbouncer-config --from-file=pgbouncer_secret/pgbouncer.ini --from-file=pgbouncer_secret/userlist.txt -n ${var.pod_namespace}"
  }
  depends_on = [null_resource.creds_aks, null_resource.secret_delete]
}

resource "helm_release" "pgbouncer" {
  name = "pgbouncer"
  chart        = "./pgbouncer"
  force_update = true
  namespace    = var.pod_namespace

  set {
    name  = "stateChecksum"
    value = filemd5("${path.module}/pgbouncer/templates/pgbouncer.yaml")
  }

  set {
    name  = "valueChecksum"
    value = filemd5("${path.module}/pgbouncer/values.yaml")
  }

  values     = [templatefile("${path.module}/pgbouncer/values.yaml", { db_port = var.db_port })]
  depends_on = [kubernetes_namespace.namespace, null_resource.secret_create]

}
