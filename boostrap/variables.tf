variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

variable "node_data" {
  description = "A map of node data"
  type = object({
    controlplanes = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
  })
  default = {
    controlplanes = {
      "10.0.39.11" = {
        install_disk = "/dev/sda",
        hostname     = "talos-dev-1"
      }
      "10.0.39.12" = {
        install_disk = "/dev/sda",
        hostname     = "talos-dev-2"
      }
      "10.0.39.13" = {
        install_disk = "/dev/sda",
        hostname     = "talos-dev-3"
      }
    }
  }
}
