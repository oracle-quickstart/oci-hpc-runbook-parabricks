## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_virtual_network" "GPU_VCN" {
  cidr_block     = var.VCN-CIDR
  compartment_id = var.compartment_ocid
  display_name   = "GPU_VCN"
  dns_label      = "gpuvcn"
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_subnet" "GPU_Public_Subnet" {
  availability_domain = var.availablity_domain_name
  cidr_block          = var.Subnet-CIDR
  display_name        = "GPU_Public_Subnet"
  dns_label           = "gpupubsubnet"
  security_list_ids   = [oci_core_security_list.PUBLIC-SECURITY-LIST.id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.GPU_VCN.id
  route_table_id      = oci_core_route_table.GPU_PUB_RT.id
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_internet_gateway" "GPU_IG" {
  compartment_id = var.compartment_ocid
  display_name   = "GPU_IG"
  vcn_id         = oci_core_virtual_network.GPU_VCN.id
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_route_table" "GPU_PUB_RT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.GPU_VCN.id
  display_name   = "GPU_Public_RouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.GPU_IG.id
  }
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_security_list" "PUBLIC-SECURITY-LIST" {
  display_name   = "public-security-list"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.GPU_VCN.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "all"
    source   = oci_core_virtual_network.GPU_VCN.cidr_block
  }
  ingress_security_rules {
    protocol = 6
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
