terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
    ignition = {
      source = "terraform-providers/ignition"
      version = "1.2.1"
    }
  }
}
