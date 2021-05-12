## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "region" {}
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "availablity_domain_name" {}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.0"
}

variable "gpu_shape" {
  default = "BM.GPU3.8"
}

variable "gpu_node_count" {
  default = "1"
}

variable "ssh_public_key" {
  default = ""
}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "Subnet-CIDR" {
  default = "10.0.0.0/24"
}

# Install Block NFS, value are 0 or 1
variable "block_nfs" {
  default = "True"
}

# Size in GB
variable "size_block_volume" {
  default = "1000"
}

variable "model_drive" {
  default = "block"
}

variable "devicePath" {
  default = "/dev/oracleoci/oraclevdb"
}


variable "parabricks_license" {
  default = ""
}

variable "parabricks_assets" {
  default = "https://objectstorage.us-ashburn-1.oraclecloud.com/p/OQElAR1haXBXbza-AEE2C1d7MZrS9HNtYK2LcUVZ-hOxNSt-Lk0Jc8Ihyhj9DTlR/n/hpc_limited_availability/b/parabricks/o/parabricks_assets.tar.gz"
}

