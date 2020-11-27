resource "libvirt_volume" "flatcar-disk" {
  count = var.nb_nodes

  name             = "node-${format(var.hostname_prefix, count.index)}.qcow2"
  base_volume_name = var.base_volume_name
  pool             = var.pool_name
  format           = "qcow2"
}

resource "libvirt_domain" "node" {
  count = var.nb_nodes

  name   = format(var.hostname_prefix, count.index)
  vcpu   = var.domain_vcpu
  memory = var.domain_memory

  disk {
    volume_id = element(libvirt_volume.flatcar-disk.*.id, count.index)
  }

  network_interface {
    network_name   = var.network_name
    wait_for_lease = true
  }

  coreos_ignition = element(libvirt_ignition.ignition.*.id, count.index)
  fw_cfg_name     = "opt/org.flatcar-linux/config"
}
