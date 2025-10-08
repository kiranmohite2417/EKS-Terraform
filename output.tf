output "cluster_name" {
  value = aws_eks_cluster.devopsshack.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.devopsshack.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.devopsshack.certificate_authority[0].data
}

output "node_group_name" {
  value = aws_eks_node_group.devopsshack.node_group_name
}

