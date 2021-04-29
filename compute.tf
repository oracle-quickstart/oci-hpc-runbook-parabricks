resource "oci_core_instance" "GPU_Instance" {
  count               = var.gpu_node_count
  compartment_id      = var.compartment_ocid
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  display_name        = "ParabricksGPUInstance-${count.index}"
  fault_domain        = "FAULT-DOMAIN-${(count.index%3)+1}"
  shape               = var.gpu_shape
  
  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_app_catalog_listing_resource_version.App_Catalog_Listing_Resource_Version, "listing_resource_id")
  }
  
  create_vnic_details {
    subnet_id = oci_core_subnet.GPU_Public_Subnet.id
  }
  
  metadata = {
     ssh_authorized_keys = tls_private_key.key.public_key_openssh
  }
  defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
