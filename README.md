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


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | 1.35.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.35.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_k3s"></a> [k3s](#module\_k3s) | git@github.com:dmalykh/terraform-module-k3s.git | n/a |

## Resources

| Name | Type |
|------|------|
| [hcloud_network.private](https://registry.terraform.io/providers/hetznercloud/hcloud/1.35.2/docs/resources/network) | resource |
| [hcloud_network_subnet.private_subnet](https://registry.terraform.io/providers/hetznercloud/hcloud/1.35.2/docs/resources/network_subnet) | resource |
| [hcloud_server.agent](https://registry.terraform.io/providers/hetznercloud/hcloud/1.35.2/docs/resources/server) | resource |
| [hcloud_server.master](https://registry.terraform.io/providers/hetznercloud/hcloud/1.35.2/docs/resources/server) | resource |
| [hcloud_server_network.agent](https://registry.terraform.io/providers/hetznercloud/hcloud/1.35.2/docs/resources/server_network) | resource |
| [hcloud_server_network.master](https://registry.terraform.io/providers/hetznercloud/hcloud/1.35.2/docs/resources/server_network) | resource |
| [hcloud_ssh_key.default](https://registry.terraform.io/providers/hetznercloud/hcloud/1.35.2/docs/resources/ssh_key) | resource |
| [kubernetes_cluster_role_binding.boostrap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_service_account.bootstrap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [hcloud_image.os](https://registry.terraform.io/providers/hetznercloud/hcloud/1.35.2/docs/data-sources/image) | data source |
| [kubernetes_secret.sa_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |
| [template_file.init](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent"></a> [agent](#input\_agent) | Agent nodes | <pre>object({<br>    count = optional(number, 0)<br>    name = optional(string, "agent")<br>    server_type = string<br>  })</pre> | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | K3s network CIDRs (see https://rancher.com/docs/k3s/latest/en/installation/install-options/). | <pre>object({<br>    pods     = string<br>    services = string<br>  })</pre> | <pre>{<br>  "pods": "10.42.0.0/16",<br>  "services": "10.43.0.0/16"<br>}</pre> | no |
| <a name="input_cloud-init"></a> [cloud-init](#input\_cloud-init) | n/a | `string` | `""` | no |
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | n/a | `string` | n/a | yes |
| <a name="input_ipadd"></a> [ipadd](#input\_ipadd) | Add to IP addresses sequesce to avoid zero-ip defenition | `number` | `1` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"hel1"` | no |
| <a name="input_master"></a> [master](#input\_master) | Control plane nodes | <pre>object({<br>    count = optional(number, 0)<br>    name = optional(string, "master")<br>    server_type = string<br>  })</pre> | n/a | yes |
| <a name="input_networking"></a> [networking](#input\_networking) | n/a | <pre>object({<br>    name = optional(string, "private")<br>    ip_range = optional(string, "10.0.0.0/8")<br>    type = optional(string, "cloud")<br>    network_zone = optional(string, "eu-central")<br>    sub_ip_range = optional(string, "10.254.1.0/24")<br>  })</pre> | `{}` | no |
| <a name="input_os"></a> [os](#input\_os) | Operating system that will be installed on a server | `string` | `"ubuntu-22.04"` | no |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | n/a | <pre>object({<br>    name = optional(string, "default")<br>    public_key = string<br>    private_key = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap_sa"></a> [bootstrap\_sa](#output\_bootstrap\_sa) | Bootstrap ServiceAccount. Can be used by Terraform to provision this cluster. |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
| <a name="output_summary"></a> [summary](#output\_summary) | Output |
<!-- END_TF_DOCS -->