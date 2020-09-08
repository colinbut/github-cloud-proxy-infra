output "repository_arn" {
    value = aws_ecr_repository.github_cloud_proxy_container_repository.arn
}

output "registry_id" {
    value = aws_ecr_repository.github_cloud_proxy_container_repository.registry_id
}

output "repository_url" {
    value = aws_ecr_repository.github_cloud_proxy_container_repository.repository_url
}