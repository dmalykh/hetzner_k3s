# Networking
resource "hcloud_network" "private" {
  name     = var.networking.name
  ip_range = var.networking.ip_range
}

resource "hcloud_network_subnet" "private_subnet" {
  type         = var.networking.type
  network_id   = hcloud_network.private.id
  network_zone = var.networking.network_zone
  ip_range     = var.networking.sub_ip_range
}
