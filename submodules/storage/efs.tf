resource "aws_efs_file_system" "eks" {
  encrypted                       = "true"
  performance_mode                = "generalPurpose"
  provisioned_throughput_in_mibps = "0"
  throughput_mode                 = "bursting"

  tags = merge({ "Name" = "${var.deploy_id}" }, var.tags)
}


resource "aws_efs_access_point" "eks" {
  file_system_id = aws_efs_file_system.eks.id

  posix_user {
    gid = "0"
    uid = "0"
  }

  root_directory {
    creation_info {
      owner_gid   = "0"
      owner_uid   = "0"
      permissions = "777"
    }

    path = var.efs_access_point_path
  }
  tags = var.tags
}

