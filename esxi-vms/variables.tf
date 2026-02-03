variable "vsphere_user" {
  description = "vSphere username"
  type        = string
  sensitive   = true
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vSphere server hostname or IP"
  type        = string
}

variable "vsphere_insecure" {
  description = "Allow unverified SSL certificates"
  type        = bool
  default     = true
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter name"
  type        = string
}

variable "vsphere_host" {
  description = "vSphere ESXi host name"
  type        = string
}

variable "vsphere_datastore" {
  description = "vSphere datastore name"
  type        = string
}

variable "vsphere_network" {
  description = "vSphere network name"
  type        = string
}


variable "vm_cpu" {
  description = "Number of vCPUs"
  type        = number
  default     = 4
}

variable "vm_memory" {
  description = "Amount of memory in MB"
  type        = number
  default     = 16384
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 100
}

variable "vm_guest_id" {
  description = "Guest OS identifier"
  type        = string
  default     = "ubuntu64Guest"
}

variable "talos_nodes" {
  description = "Map of Talos nodes to create"
  type = map(object({
    name = string
    # config_file = string
  }))
  default = {
    "master1" = {
      name = "talos-dev-1"
    }
    "master2" = {
      name = "talos-dev-2"
    }
    "master3" = {
      name = "talos-dev-3"
    }
  }
}
