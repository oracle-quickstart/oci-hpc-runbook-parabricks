## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "HeadNodesPublicIPs" {
  value = [oci_core_instance.GPU_Instance.*.public_ip]
}
output "HeadNodesPrivateIPs" {
  value = [oci_core_instance.GPU_Instance.*.private_ip]
}
output "Private_key" {
  value = tls_private_key.key.private_key_pem
}
