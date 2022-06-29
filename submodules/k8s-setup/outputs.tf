output "k8s_tunnel_command" {
  value = "docker run -d -v $PWD/${local.mallory_config_filename}:${local.mallory_config_path_container} -p ${var.mallory_local_normal_port}:${var.mallory_local_normal_port} -p ${var.mallory_local_smart_port}:${var.mallory_local_smart_port} -v ${var.pvt_key_path}:${local.pvt_key_path_container} zoobab/mallory"

}
