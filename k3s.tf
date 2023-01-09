# K3s 
module "k3s" {
  source = "git@github.com:xunleii/terraform-module-k3s.git"

  depends_on_    = hcloud_server_network.agent
  k3s_version    = "latest"
  cluster_domain = "cluster.local"
  cidr = {
    pods     = "10.42.0.0/16"
    services = "10.43.0.0/16"
  }
  drain_timeout  = "30s"
  managed_fields = ["label", "taint"] // ignore annotations

  global_flags = [
    "--flannel-iface ens10",
  ]

  use_sudo = true

  servers = {
    for i in range(length(hcloud_server.master)) :
    hcloud_server.master[i].name => {
      ip = hcloud_server_network.master[i].ip
      connection = {
          type     = "ssh"
          user = "root"
          host = hcloud_server.master[i].ipv4_address
          private_key = "${var.ssh_key.private_key}"
      }
      flags       = ["--disable-cloud-controller"]
      annotations = { "server_id" : i } // theses annotations will not be managed by this module
    }
  }

  agents = {
    for i in range(length(hcloud_server.agent)) :
    "${hcloud_server.agent[i].name}_node" => {
      name = hcloud_server.agent[i].name
      ip   = hcloud_server_network.agent[i].ip
      connection = {
          type     = "ssh"
          user = "root"
          host = hcloud_server.agent[i].ipv4_address
          private_key = "${var.ssh_key.private_key}"
      }
    }
  }
}

provider "kubernetes" {
  host                   = module.k3s.kubernetes.api_endpoint
  cluster_ca_certificate = module.k3s.kubernetes.cluster_ca_certificate
  client_certificate     = module.k3s.kubernetes.client_certificate
  client_key             = module.k3s.kubernetes.client_key
}

resource "kubernetes_service_account" "bootstrap" {
  depends_on = [module.k3s.kubernetes_ready]

  metadata {
    name      = "bootstrap"
    namespace = "default"
  }
}

resource "kubernetes_cluster_role_binding" "boostrap" {
  depends_on = [module.k3s.kubernetes_ready]

  metadata {
    name = "bootstrap"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "bootstrap"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
}

data "kubernetes_secret" "sa_credentials" {
  metadata {
    name      = kubernetes_service_account.bootstrap.default_secret_name
    namespace = "default"
  }
}