#Variables authorization
variable "VDC_ADM" {

  default = "aspop54"

}

variable "VDC_PASS" {

  default = "Popass2021"

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
