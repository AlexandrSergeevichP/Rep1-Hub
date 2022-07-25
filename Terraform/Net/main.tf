# Configure the VMware Cloud Director Provider
terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.6.0"
    }
  }
}


resource "vcd_network_routed_v2" "network69" {

  name            = "10.24.69.0/24"

  vdc             = var.VDC

  edge_gateway_id = data.vcd_edgegateway.aspop54_EdgeGW.id

  prefix_length   = 24

  interface_type  = "subinterface"

  gateway      = "10.24.69.1"

  dns1         = "10.24.12.28"

  dns2         = "10.24.12.29"

  description  = "Test"

  static_ip_pool {
    start_address = "10.24.69.210"
    end_address   = "10.24.69.240"
  }
}

data "vcd_edgegateway" "aspop54_EdgeGW" {
  name = "aspop54_EdgeGW"
}

output "edge_gateway_id" {
  value = data.vcd_edgegateway.aspop54_EdgeGW.id
}
