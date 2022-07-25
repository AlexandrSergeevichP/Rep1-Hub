# Configure the VMware Cloud Director Provider
terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.6.0"
    }
  }
}
# Configuration option
provider "vcd" {
    user                 = var.VDC_ADM
    password             = var.VDC_PASS
    auth_type            = "integrated"
    org                  = var.VDC_ORG
    vdc                  = var.VDC
    url                  = var.VDC_URL
    max_retry_timeout    = var.vcd_org_max_retry_timeout
    allow_unverified_ssl = var.vcd_org_allow_unverified_ssl
}
# Create Vapp vApp-TR
resource "vcd_vapp" "vApp-TR" {
  name = "vApp-TR"
}

# Connect vApp to Direct-Net Sub-Net-01
resource "vcd_vapp_org_network" "Sub-Net-01" {
  vapp_name = vcd_vapp.vApp-TR.name
  # Comment below line to create an isolated vApp network
  org_network_name = "Sub-Net-01"
}
# Create VM TR-VM1
resource "vcd_vapp_vm" "TR-VM1" {

  vapp_name        = vcd_vapp.vApp-TR.name
  name             = "TR-VM1"
  catalog_name     = "Linux"
  template_name    = "CentOS-7-2009-x86-64-Eng-Server"
  #os_type = "Linux"
  memory           = 2048
  cpus             = 2
  cpu_cores        = 2
  hardware_version = "vmx-15"
  #depends_on = [vcd_vapp.vApp-TR1]


  guest_properties = {
    "guest.hostname"   = "C7-SRV01"
   }

  customization {
            enabled                             = true
            auto_generate_password              = false
            admin_password                      = var.ADMPASS
   }

   override_template_disk {
    bus_type        = "paravirtual"
    size_in_mb      = (20 * 1024)
    bus_number      = 0
    unit_number     = 0
    #iops            = 0
    storage_profile = "54_SSD_Ultra_Policy"
  }

   network {
            type               = "org"
            adapter_type       = "VMXNET3"
            connected          = true
            ip                 = "10.10.10.5"
            ip_allocation_mode = "MANUAL"
            #is_primary         =
            #mac                =
            name               = vcd_vapp_org_network.Sub-Net-01.org_network_name
  }
}
# Create Disk and Add to VM TR-VM1
resource "vcd_vm_internal_disk" "Disk" {
  vapp_name       = vcd_vapp.vApp-TR.name
  vm_name         = "TR-VM1"
  bus_type        = "paravirtual"
  size_in_mb      = (20 * 1024)
  bus_number      = 0
  unit_number     = 1
  storage_profile = "54_SSD_Basic_Policy"
  allow_vm_reboot = true
  depends_on      = [vcd_vapp_vm.TR-VM1]
}
# Create VM TR-VM1
resource "vcd_vapp_vm" "TR-VM2" {

  vapp_name        = vcd_vapp.vApp-TR.name
  name             = "TR-VM2"
  catalog_name     = "Linux"
  template_name    = "CentOS-7-2009-x86-64-Eng-Server"
  #os_type = "Linux"
  memory           = 2048
  cpus             = 2
  cpu_cores        = 2
  hardware_version = "vmx-15"
  #depends_on = [vcd_vapp.vApp-TR1]


  guest_properties = {
    "guest.hostname"   = "C7-SRV02"
   }

  customization {
            enabled                             = true
            auto_generate_password              = false
            admin_password                      = var.ADMPASS
   }

   override_template_disk {
    bus_type        = "paravirtual"
    size_in_mb      = (20 * 1024)
    bus_number      = 0
    unit_number     = 0
    #iops            = 0
    storage_profile = "54_SSD_Ultra_Policy"
  }

   network {
            type               = "org"
            adapter_type       = "VMXNET3"
            connected          = true
            ip                 = "10.10.10.6"
            ip_allocation_mode = "MANUAL"
            #is_primary         =
            #mac                =
            name               = vcd_vapp_org_network.Sub-Net-01.org_network_name
  }
}
# Create Disk and Add to VM TR-VM2
resource "vcd_vm_internal_disk" "Disk2" {
  vapp_name       = vcd_vapp.vApp-TR.name
  vm_name         = "TR-VM2"
  bus_type        = "paravirtual"
  size_in_mb      = (20 * 1024)
  bus_number      = 0
  unit_number     = 1
  storage_profile = "54_SSD_Basic_Policy"
  allow_vm_reboot = true
  depends_on      = [vcd_vapp_vm.TR-VM2]
}

/*
resource "vcd_nsxv_snat" "SNAT-TR-VM1" {
  #org = "my-org" # Optional
  #vdc = "my-vdc" # Optional
  #rule_tag = 204813
  rule_type = "users"
  edge_gateway = "aspop54_test-EdgeGW"
  network_type = "ext"
  network_name = "ClientsExternalNetwork"
  enabled         = true
  logging_enabled = false
  original_address   = "10.10.10.5"
  translated_address = "176.118.21.50"
}
*/
resource "vcd_nsxv_dnat" "DNAT-TR-VM1" {
  #org = "my-org" # Optional
  #vdc = "my-vdc" # Optional
  #rule_tag = 204814
  rule_type = "users"
  edge_gateway = "aspop54_test-EdgeGW"
  network_name = "ClientsExternalNetwork"
  network_type = "ext"

  enabled         = true
  logging_enabled = false
  description     = "DNAT-TR-VM1"

  original_address = "176.118.21.50"
  original_port    = 2225

  translated_address = "10.10.0.5"
  translated_port    = 22
  protocol           = "tcp"
}
/*
resource "vcd_nsxv_snat" "SNAT-TR-VM2" {
  #org = "my-org" # Optional
  #vdc = "my-vdc" # Optional
  #rule_tag = 204813
  rule_type = "users"
  edge_gateway = "aspop54_test-EdgeGW"
  network_type = "ext"
  network_name = "ClientsExternalNetwork"
  enabled         = true
  logging_enabled = false
  original_address   = "10.10.10.6"
  translated_address = "176.118.21.50"
}
*/
resource "vcd_nsxv_dnat" "DNAT-TR-VM2" {
  #org = "my-org" # Optional
  #vdc = "my-vdc" # Optional
  #rule_tag = 204814
  rule_type = "users"
  edge_gateway = "aspop54_test-EdgeGW"
  network_name = "ClientsExternalNetwork"
  network_type = "ext"

  enabled         = true
  logging_enabled = false
  description     = "DNAT-TR-VM2"

  original_address = "176.118.21.50"
  original_port    = 2226

  translated_address = "10.10.0.6"
  translated_port    = 22
  protocol           = "tcp"
}

resource "vcd_nsxv_firewall_rule" "Rule-TR-VM1" {
  #org          = "my-org"
  #vdc          = "my-vdc"
  edge_gateway = "aspop54_test-EdgeGW"
  name         = "SSH-TR-VM1"
  action       = "accept"
  source {
    ip_addresses       = ["any"]
    #gateway_interfaces = ["internal"]
  }
  destination {
    ip_addresses = ["176.118.21.50"]
  }
  service {
    protocol = "tcp"
    port     = "2225"
  }
}

resource "vcd_nsxv_firewall_rule" "Rule-TR-VM2" {
  #org          = "my-org"
  #vdc          = "my-vdc"
  edge_gateway = "aspop54_test-EdgeGW"
  name         = "SSH-TR-VM2"
  action       = "accept"
  source {
    ip_addresses       = ["any"]
    #gateway_interfaces = ["internal"]
  }
  destination {
    ip_addresses = ["176.118.21.50"]
  }
  service {
    protocol = "tcp"
    port     = "2226"
  }
}
