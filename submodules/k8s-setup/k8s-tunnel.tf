
locals {
  mallory_config_filename       = "mallory.json"
  mallory_config_path_local     = "${path.module}/../../${local.mallory_config_filename}"
  mallory_config_path_container = "/root/.config/${local.mallory_config_filename}"
  pvt_key_path_container        = "/root/${basename(var.pvt_key_path)}"
  mallory_local_normal_port     = "1315"
  mallory_local_smart_port      = "1316"
}

resource "local_file" "mallory" {
  content = jsonencode({
    "id_rsa"       = local.pvt_key_path_container
    "local_smart"  = ":${var.mallory_local_normal_port}"
    "local_normal" = ":${var.mallory_local_smart_port}"
    "remote"       = "ssh://${var.bastion_user}@${var.bastion_public_ip}:22"
    "blocked"      = [var.k8s_cluster_endpoint]
  })
  filename = local.mallory_config_filename
}


## very flaky to manage the lifecycle of the tunnel here.

# resource "docker_container" "mallory" {
#   name  = "k8s-tunnel-mallory"
#   image = "zoobab/mallory"

#   upload {
#     file   = local.mallory_config_path_container
#     source = local.mallory_config_path_local
#   }

#   upload {
#     file   = local.pvt_key_path_container
#     source = var.pvt_key_path
#   }

#   ports {
#     internal = var.mallory_local_normal_port
#     external = var.mallory_local_normal_port
#     ip       = "0.0.0.0"
#   }

#   ports {
#     internal = var.mallory_local_smart_port
#     external = var.mallory_local_smart_port
#     ip       = "0.0.0.0"
#   }

#   labels {
#     label = "mallory_config"
#     value = local_file.mallory.id
#   }

#   labels {
#     label = "timestamp"
#     value = timestamp()
#   }

#   depends_on = [
#     local_file.mallory
#   ]
# }


## If we kill mallory, then any subsequent plan will cause it to fail

# resource "null_resource" "kill_mallory" {
#   provisioner "local-exec" {
#     command     = "docker container kill ${docker_container.mallory.id} && docker rm ${docker_container.mallory.id} --force"
#     interpreter = ["bash", "-c"]
#   }

#   depends_on = [
#     docker_container.mallory,
#     helm_release.calico,
#     kubernetes_namespace.domino
#   ]

#   triggers = {
#     mallory_container_id = docker_container.mallory.id
#   }

# }

