output "HeadNodesPublicIPs" {
  value = [oci_core_instance.GPU_Instance.*.public_ip]
}
output "HeadNodesPrivateIPs" {
  value = [oci_core_instance.GPU_Instance.*.private_ip]
}
output "Private_key" {
  value = tls_private_key.key.private_key_pem
}
