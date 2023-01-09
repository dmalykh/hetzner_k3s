variable "hcloud_token" {
  type = string
}

variable "cloud-init" {
  type = string
  default = "cloud-init.yml"
}

variable "os" {
  description = "Operating system that will be installed on a server"
  type = string
  default = "ubuntu-22.04"
}

variable "location" {
  type = string
  default = "hel1"
}

variable "ssh_key" {
  type = object({
    name = optional(string, "default")
    public_key = string
    private_key = string
  })
}

variable "ipadd" {
  type = number
  default = 1
  description = "Add to IP addresses sequesce to avoid zero-ip defenition"
}

variable "networking" {
  type = object({
    name = optional(string, "private")
    ip_range = optional(string, "10.0.0.0/8")
    type = optional(string, "cloud")
    network_zone = optional(string, "eu-central")
    sub_ip_range = optional(string, "10.254.1.0/24")
  })
}

variable "loadbalancer" {
  description = "Load balancer settings"
  type = object({
    count = optional(number, 0)
    name = optional(string, "loadbalancer")
    server_type = string
  })
}

variable "master" {
  description = "Control plane nodes"
  type = object({
    count = optional(number, 0)
    name = optional(string, "master")
    server_type = string
  })
}

variable "agent" {
  description = "Agent nodes"
  type = object({
    count = optional(number, 0)
    name = optional(string, "agent")
    server_type = string
  })
}

# K3S vars https://github.com/xunleii/terraform-module-k3s/blob/master/variables.tf
variable "cidr" {
  description = "K3s network CIDRs (see https://rancher.com/docs/k3s/latest/en/installation/install-options/)."
  type = object({
    pods     = string
    services = string
  })
  default = {
    pods     = "10.42.0.0/16"
    services = "10.43.0.0/16"
  }
}