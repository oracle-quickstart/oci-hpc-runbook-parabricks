## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_file" "key_file" {
  filename = "key.pem"
  content  = tls_private_key.key.private_key_pem

  provisioner "local-exec" {
    command = "chmod 600 key.pem"
  }

}
