# Stack Kubernetes KVM

Deploy a Kubernetes cluster backed with an etcd cluster on KVM infra.

## Requirements

### Terraform

`terraform-provider-ignition` and `libvirt` Terraform providers locally available.

```hcl
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
```

### KVM

One dedicated started volume pool to host the volumes created.

```shell
$ virsh pool-list
 Name              State    Autostart
---------------------------------------
 kubernetes-pool   active   yes
```

One base volume stored in the dedicated pool holding the Flatcar `qemu` [image](https://docs.flatcar-linux.org/os/booting-with-qemu/#choosing-a-channel):
```shell
$ virsh vol-list --pool kubernetes-pool
 Name                                Path
------------------------------------------------------------------------------------------------------
 flatcar_production_qemu_image.img   /path/to/flatcar_production_qemu_image.img
```
