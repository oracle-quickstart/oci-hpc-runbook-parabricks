## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_volume" "GPU_BV" {
  count               = var.gpu_node_count
  availability_domain  = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id       = var.compartment_ocid
  size_in_gbs          = var.size_block_volume
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_volume_attachment" "GPU_BlockAttach" {
  count           = var.gpu_node_count
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.GPU_Instance[count.index].id
  volume_id       = oci_core_volume.GPU_BV[count.index].id
  device          = var.devicePath
}
