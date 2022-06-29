output "efs_volume_handle" {
  value = "${aws_efs_access_point.eks.file_system_id}::${aws_efs_access_point.eks.id}"
}
