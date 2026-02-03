data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}
data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_resource_pool" "pool" {
  name          = format("%s%s", data.vsphere_host.host.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Remove the content library data sources - no longer needed
# data "vsphere_content_library" "library" { ... }
# data "vsphere_content_library_item" "template" { ... }

resource "vsphere_virtual_machine" "vm" {
  for_each = var.talos_nodes
  
  name             = each.value.name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.vm_cpu
  memory           = var.vm_memory
  guest_id         = var.vm_guest_id
  
  # Boot firmware - use "efi" for UEFI PXE boot
  firmware = "efi"  # or "bios" for legacy BIOS PXE
  
  # Enable network boot
  boot_delay = 5000  # 5 second delay (optional)
  
  # Configure EFI settings for network boot
  efi_secure_boot_enabled = false  # Usually needed for PXE
  
  wait_for_guest_net_timeout  = 5
  wait_for_guest_ip_timeout   = 5
  wait_for_guest_net_routable = false
  enable_disk_uuid            = true
  
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  
  disk {
    label = "disk0"
    size  = var.vm_disk_size
  }
  
  disk {
    label       = "disk1"
    size        = 256
    unit_number = 1
  }
  
  # REMOVE the clone block entirely
  # clone {
  #   template_uuid = data.vsphere_content_library_item.template.id
  # }
}

# Your outputs remain the same
output "vm_ip_addresses" {
  description = "Map of VM names to their IP addresses"
  value = {
    for k, vm in vsphere_virtual_machine.vm : k => vm.default_ip_address
  }
}

output "vm_details" {
  description = "Detailed information for all VMs"
  value = {
    for k, vm in vsphere_virtual_machine.vm : k => {
      name               = vm.name
      primary_ip         = vm.default_ip_address
      all_ips            = vm.guest_ip_addresses
      power_state        = vm.power_state
      uuid               = vm.uuid
    }
  }
}

output "all_vm_ips" {
  description = "List of all VM IP addresses"
  value       = [for vm in vsphere_virtual_machine.vm : vm.default_ip_address]
}

output "vm_ipv4_addresses" {
  description = "Map of VM names to IPv4 addresses only"
  value = {
    for k, vm in vsphere_virtual_machine.vm : k => [
      for ip in vm.guest_ip_addresses :
      ip if can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", ip))
    ]
  }
}

output "ansible_inventory" {
  description = "Ansible inventory format with VM IPs"
  value = templatefile("${path.module}/inventory.tpl", {
    vms = {
      for k, vm in vsphere_virtual_machine.vm : vm.name => vm.default_ip_address
    }
  })
}

output "vm_lookup" {
  description = "Look up any VM's IP by its key"
  value       = "Use: terraform output -json vm_ip_addresses | jq '.controlplane1'"
}
