#Variables authorization
variable "VDC_ADM" {
  default = "aspop54"
}

variable "VDC_PASS" {
  default = "Popass2021"
}

variable "ADMPASS" {
  type = string
  default = "Myaush2021"
}

variable "VDC_ORG" {
  default = "aspop54_testorg"
}

variable "VDC" {
  default = "aspop54_VDC"
}

variable "VDC_URL" {
  default = "https://iaas.cloud.mts.ru/api"
}


variable "vcd_org_max_retry_timeout" {
  default = "60"
}

variable "vcd_org_allow_unverified_ssl" {
  default = "true"
}

variable "SSD_POLICY" {
  #type = string
  default = "99_SSD_Ultra_Policy"
}

variable "FAST_POLICY" {
  #type = string
  default = "99_SSD_Fast_Policy"
}

variable "UBUNTU_20_04" {
  type = string
  default = "Ubuntu-20.04.3-amd64-Eng-Server"
}

variable "CATALOG_UBUNTU" {
  #type = string
  default = "Linux (AVNTG)"
}

variable "EDGE_GW" {
  #type = string
  default = "aspop54_EdgeGW"
}

variable "EXERNAL_NET" {
  #type = string
  default = "ClientExternalNetwork_AVNTG"
}

#variable "EXERNAL_IP" {
  #type = string
  #default = "89.22.181.250"
#}
