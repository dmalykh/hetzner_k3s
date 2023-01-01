terraform {
  required_providers {
    hcloud = {
        source = "hetznercloud/hcloud"
        version = "1.35.2"
    }
  }
}

provider "hcloud" {
    token = var.hcloud_token
}

data "hcloud_image" "os" {
  name = var.os
}

data "template_file" "init" {
  template = "${var.cloud-init}"
}

resource "hcloud_ssh_key" "default" {
  name       = var.ssh_key.name
  public_key = var.ssh_key.public_key
}