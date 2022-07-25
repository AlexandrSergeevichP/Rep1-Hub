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

  name = "vApp-TR1"

}
# Create VM TR-VM1
resource "vcd_vapp_vm" "TR-VM1" {

  vapp_name = vcd_vapp.vApp-TR.name
  name = "TR-VM1"
  catalog_name = "Linux (AVNTG)"
  template_name = "CentOS-7-2009-x86-64-Eng-Server"
  #os_type = "Linux"
  memory = 2048
  cpus = 2
  cpu_cores = 2
  #depends_on = [vcd_vapp.vApp-TR1]


}

# Create Disk and Add to VM TR-VM1
resource "vcd_vm_internal_disk" "Disk" {
  vapp_name       = vcd_vapp.vApp-TR.name
  vm_name         = "TR-VM1"
  bus_type        = "paravirtual"
  size_in_mb      = "51200"
  bus_number      = 0
  unit_number     = 0
  storage_profile = "99_SSD_Ultra_Policy"
  allow_vm_reboot = true
  #depends_on      = ["vcd_vapp_vm.TR-VM1"]
}
