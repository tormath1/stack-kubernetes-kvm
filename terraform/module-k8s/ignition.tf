data "ignition_config" "ignition" {
  count = var.nb_nodes

  users = [
    data.ignition_user.core.rendered,
  ]

  files = [
    element(data.ignition_file.hostname.*.rendered, count.index)
  ]

  networkd = [
    data.ignition_networkd_unit.network-dhcp.rendered,
  ]

  systemd = [
    data.ignition_systemd_unit.etcd-member[count.index].rendered,
    data.ignition_systemd_unit.setup-net-environment.rendered,
  ]
}

data "ignition_user" "core" {
  name = "core"
  ssh_authorized_keys = [
    local.ssh_pub_key,
  ]
}

data "ignition_file" "hostname" {
  count = var.nb_nodes

  filesystem = "root"
  path       = "/etc/hostname"
  mode       = 420
  content {
    content = format(var.hostname_prefix, count.index)
  }
}

data "ignition_networkd_unit" "network-dhcp" {
  name    = "00-wired.network"
  content = file("${path.module}/templates/00-wired.network")
}

data "ignition_systemd_unit" "etcd-member" {
  count = var.nb_nodes

  name    = "etcd-member.service"
  enabled = true
  dropin {
    content = data.template_file.etcd-member[count.index].rendered
    name    = "10-etcd-member.conf"
  }
}

data "template_file" "etcd-member" {
  count = var.nb_nodes

  template = file("${path.module}/templates/10-etcd-member.conf")
  vars = {
    node_name          = format(var.hostname_prefix, count.index)
    cluster_token      = random_string.token.result
    etcd_discovery_url = var.etcd_discovery_url
  }
}

resource "random_string" "token" {
  length  = 16
  special = false
}

resource "libvirt_ignition" "ignition" {
  count = var.nb_nodes

  name    = "${format(var.hostname_prefix, count.index)}-ignition"
  pool    = var.pool_name
  content = element(data.ignition_config.ignition.*.rendered, count.index)
}

data "ignition_systemd_unit" "setup-net-environment" {
  name    = "setup-network-environment.service"
  content = file("${path.module}/templates/05-setup-network-environment.service")
}
