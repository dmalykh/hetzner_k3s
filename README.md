Terraform module for creating K3S cluster using Hetzner cloud services.

```
module "infrastructure" {
 source  = "git@github.com:dmalykh/hetzner_k3s.git"
 
 hcloud_token = "${var.hcloud_token}"
 os = "ubuntu-22.04"
 location = "hel1"

 ssh_key = {
    public_key = "${var.public_key}"
    private_key = file("${var.private_key}")
 }

 master = {
    count = 3
    server_type = "cx21"
 }

 agent = {
    count = 6
    server_type = "cx11"
 }
}

resource "local_sensitive_file" "kubeconfig_file" {
    content = module.infrastructure.kube_config
    filename = "./.kubeconfig"
}
```