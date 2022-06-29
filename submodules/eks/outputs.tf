
output "security_group_id" {
  value = aws_security_group.eks_cluster.id
}

output "nodes_security_group_id" {
  value = aws_security_group.eks_nodes.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "managed_nodes_role_arns" {
  value = [aws_iam_role.eks_nodes.arn]
}

