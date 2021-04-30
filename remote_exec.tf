resource "null_resource" "remote-exec-GPU" {
  count      = var.gpu_node_count
  depends_on = [oci_core_instance.GPU_Instance]

  provisioner "file" {
    destination = "/home/ubuntu/.ssh/id_rsa"
    content     = tls_private_key.key.private_key_pem
    #source      = "key.pem"

    connection {
      timeout     = "15m"
      host        = data.oci_core_vnic.GPU_Instance_Primary_VNIC[count.index].public_ip_address
      user        = "ubuntu"
      private_key = tls_private_key.key.private_key_pem
      agent       = false
    }
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "15m"
      host        = data.oci_core_vnic.GPU_Instance_Primary_VNIC[count.index].public_ip_address
      user        = "ubuntu"
      private_key = tls_private_key.key.private_key_pem
    }

    inline = [
      "echo '${var.ssh_public_key}' >> /home/ubuntu/.ssh/authorized_key",
    ]
  }

  provisioner "file" {
    destination = "/home/ubuntu/gpu-start.sh"
    source      = "./scripts/gpu-start.sh"

    connection {
      timeout     = "15m"
      host        = data.oci_core_vnic.GPU_Instance_Primary_VNIC[count.index].public_ip_address
      user        = "ubuntu"
      private_key = tls_private_key.key.private_key_pem
      agent       = false
    }
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "15m"
      host        = data.oci_core_vnic.GPU_Instance_Primary_VNIC[count.index].public_ip_address
      user        = "ubuntu"
      private_key = tls_private_key.key.private_key_pem
    }

    inline = [
      "sudo chmod 755 ~/gpu-start.sh",
      "~/gpu-start.sh ${oci_core_virtual_network.GPU_VCN.cidr_block} \"${element(concat(oci_core_volume_attachment.GPU_BlockAttach[count.index].*.iqn, list("")), 0)}\" ${element(concat(oci_core_volume_attachment.GPU_BlockAttach[count.index].*.ipv4, list("")), 0)}:${element(concat(oci_core_volume_attachment.GPU_BlockAttach[count.index].*.port, list("")), 0)} | tee ~/gpu-start.log",
      "mv ~/gpu-start.log /mnt/block/logs/",
    ]
  }
}


