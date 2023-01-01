# Control plane nodes
resource "hcloud_server" "agent" {
    count = var.agent.count
    name  = "${var.agent.name}-${count.index}"
    location = var.location
    server_type = var.agent.server_type
    image = data.hcloud_image.os.name
    user_data = data.template_file.base.rendered
    backups = false
    ssh_keys = [hcloud_ssh_key.default.id]

    public_net {
      ipv4_enabled = true
      ipv6_enabled = true
    }

    provisioner "remote-exec" {
        inline = [
          "cloud-init status --wait --long",
        ]
    }

    connection {
        type     = "ssh"
        user = "root"
        host = self.ipv4_address
        private_key = "${var.ssh_key.private_key}"
    }
}

resource "hcloud_server_network" "agent" {
  count     = length(hcloud_server.agent)
  subnet_id = hcloud_network_subnet.private_subnet.id
  server_id = hcloud_server.agent[count.index].id
  ip        = cidrhost(hcloud_network_subnet.private_subnet.ip_range, var.ipadd + count.index + length(hcloud_server.master))

  depends_on = [
      hcloud_server.agent
  ]
}