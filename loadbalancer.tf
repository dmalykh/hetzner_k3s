resource "hcloud_server" "loadbalancer" {
    count = var.loadbalancer.count
    name  = "${var.loadbalancer.name}-${count.index}"
    location = var.location
    server_type = var.loadbalancer.server_type
    image = data.hcloud_image.os.name
    user_data = data.template_file.init.rendered
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