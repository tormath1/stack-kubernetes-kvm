variable "nb_nodes" {
  type        = number
  default     = 2
  description = "Number of nodes."
}

variable "hostname_prefix" {
  type        = string
  default     = "node-%02d"
  description = "Hostname prefix to set on Linux nodes."
}

variable "domain_vcpu" {
  type        = number
  default     = 1
  description = "Number of vCPU per domain."

  validation {
    condition     = var.domain_vcpu > 0
    error_message = "Number of domain vCPU must be > 0."
  }
}

variable "domain_memory" {
  type        = number
  default     = 1024
  description = "Memory (in MB) to allocate per domain."
}

variable "network_name" {
  type        = string
  default     = "default"
  description = "Name of the network name to use."
}

variable "pool_name" {
  type        = string
  default     = "kubernetes-pool"
  description = "Name of the pool where volume will be hosted."
}

variable "base_volume_name" {
  type        = string
  default     = "flatcar_production_qemu_image.img"
  description = "Name of the base volume name used to create node disk."
}

variable "ssh_pub_path" {
  type        = string
  default     = "./ssh.pub"
  description = "Path of the SSH public key to associate to `core` user."

  validation {
    condition     = fileexists(var.ssh_pub_path)
    error_message = "SSH Public key path is not a valid path."
  }
}

variable "etcd_discovery_url" {
  type        = string
  description = "ETCD discovery URL, can be a custom or a SAAS one."
}

locals {
  ssh_pub_key = file(var.ssh_pub_path)
}
