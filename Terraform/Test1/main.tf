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

  name        = "vApp-TR"
  power_on    = true
}

data "vcd_edgegateway" "aspop54_EdgeGW" {
  name = "aspop54_EdgeGW"
}

output "edge_gateway_id" {
  value = data.vcd_edgegateway.aspop54_EdgeGW.id
}

# Create Vapp network vApp-Net1
resource "vcd_vapp_network" "vApp-Net" {
  name               = "vApp-Net"
  vapp_name          = vcd_vapp.vApp-TR.name
  gateway            = "10.10.30.1"
  netmask            = "255.255.255.0"
  dns1               = "10.10.30.1"
  dns2               = "10.10.10.1"
  #dns_suffix         = "mybiz.biz"
  guest_vlan_allowed = false
  org_network_name   = "test_net"

  static_ip_pool {
    start_address = "10.10.30.2"
    end_address   = "10.10.30.254"
  }
}

resource "vcd_vapp_org_network" "Org-Net1-to-Vapp" {
    vapp_name        = vcd_vapp.vApp-TR.name

    # Comment below line to create an isolated vApp network
    org_network_name = "Org-Net1"

}

# Create network Org-Net1
resource "vcd_network_routed_v2" "Org-Net1" {

  name            = "Org-Net1"
  edge_gateway_id = data.vcd_edgegateway.aspop54_EdgeGW.id
  prefix_length   = 24
  interface_type  = "subinterface"
  gateway         = "10.10.20.1"
  dns1            = "10.10.20.1"
  dns2            = "8.8.8.8"
  description     = "Test"

  static_ip_pool {
    start_address = "10.10.20.2"
    end_address   = "10.10.20.254"
  }
}


resource "vcd_vapp_org_network" "Org-Net2-to-Vapp" {
    vapp_name        = vcd_vapp.vApp-TR.name

    # Comment below line to create an isolated vApp network
    org_network_name = "Org-Net2"

}

# Create network Org-Net2
resource "vcd_network_routed_v2" "Org-Net2" {

  name            = "Org-Net2"
  edge_gateway_id = data.vcd_edgegateway.aspop54_EdgeGW.id
  prefix_length   = 24
  interface_type  = "subinterface"
  gateway         = "10.10.40.1"
  dns1            = "10.10.40.1"
  dns2            = "8.8.8.8"
  description     = "Test"

  static_ip_pool {
    start_address = "10.10.40.2"
    end_address   = "10.10.40.254"
  }
}


# Create VM TR-VM1
resource "vcd_vapp_vm" "TR-VM1" {

  vapp_name     = vcd_vapp.vApp-TR.name
  name          = "TR-VM1"
  catalog_name  = "Linux (AVNTG)"
  template_name = "CentOS-7-2009-x86-64-Eng-Server"
  #os_type = "Linux"
  memory = 2048
  cpus = 2
  cpu_cores = 2
  #depends_on = [vcd_vapp.vApp-TR1]

  network {
    type               = "vapp"
    name               = vcd_vapp_network.vApp-Net.name
    ip_allocation_mode = "MANUAL"
    adapter_type       = "VMXNET3"
    connected          = true
    is_primary         = false
    ip                 = "10.10.30.30"
  }

  network {
    type               = "org"
    name               = vcd_vapp_org_network.Org-Net1-to-Vapp.org_network_name
    ip_allocation_mode = "MANUAL"
    adapter_type       = "VMXNET3"
    connected          = true
    is_primary         = true
    ip                 = "10.10.20.10"
  }

  network {
    type               = "org"
    name               = vcd_vapp_org_network.Org-Net2-to-Vapp.org_network_name
    ip_allocation_mode = "MANUAL"
    adapter_type       = "VMXNET3"
    connected          = true
    is_primary         = false
    ip                 = "10.10.40.10"
  }
}


# Create VM TR-VM2
resource "vcd_vapp_vm" "TR-VM2" {

  vapp_name     = vcd_vapp.vApp-TR.name
  name          = "TR-VM2"
  catalog_name  = "Linux (AVNTG)"
  template_name = "CentOS-7-2009-x86-64-Eng-Server"
  #os_type = "Linux"
  memory = 2048
  cpus = 2
  cpu_cores = 2
  #depends_on = [vcd_vapp.vApp-TR1]

  network {
    type               = "vapp"
    name               = vcd_vapp_network.vApp-Net.name
    ip_allocation_mode = "MANUAL"
    adapter_type       = "E1000E"
    connected          = true
    is_primary         = false
    ip                 = "10.10.30.20"
  }

  network {
    type               = "org"
    name               = vcd_vapp_org_network.Org-Net1-to-Vapp.org_network_name
    ip_allocation_mode = "MANUAL"
    adapter_type       = "VMXNET3"
    connected          = true
    is_primary         = true
    ip                 = "10.10.20.5"
  }

  network {
    type               = "org"
    name               = vcd_vapp_org_network.Org-Net2-to-Vapp.org_network_name
    ip_allocation_mode = "MANUAL"
    adapter_type       = "VMXNET3"
    connected          = true
    is_primary         = false
    ip                 = "10.10.40.5"
  }
}
