resource "null_resource" "remote-exec-GPU_APP_Specific" {
  count      = var.gpu_node_count 
  depends_on = [oci_core_instance.GPU_Instance, null_resource.remote-exec-GPU, ]

  provisioner "file" {
    destination = "/mnt/block/scripts/gpu-start-app.sh"
    source      = "./scripts/gpu-start-app.sh"

    connection {
      timeout     = "15m"
      user        = "ubuntu"
      host        = data.oci_core_vnic.GPU_Instance_Primary_VNIC[count.index].public_ip_address
      private_key = tls_private_key.key.private_key_pem
      agent       = false
    }
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "20m"
      host        = data.oci_core_vnic.GPU_Instance_Primary_VNIC[count.index].public_ip_address
      user        = "ubuntu"
      private_key = tls_private_key.key.private_key_pem
    }

    inline = [
      "chmod 755 /mnt/block/scripts/gpu-start-app.sh",
      "/mnt/block/scripts/gpu-start-app.sh ${oci_core_instance.GPU_Instance[count.index].private_ip} \"${var.parabricks_assets}\" \"${var.parabricks_license}\" | tee /mnt/block/logs/gpu-start-app.log",
    ]
  }
}
