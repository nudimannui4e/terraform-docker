# --- GPT-generated, I'm lazy =)
output "container_name" {
  description = "Имя запущенного Docker-контейнера GitLab"
  value       = docker_container.gitlab.name
}

output "container_id" {
  description = "ID Docker-контейнера GitLab"
  value       = docker_container.gitlab.id
}

output "web_url" {
  description = "URL веб-интерфейса GitLab"
  value       = "http://localhost:${var.http_port_external}"
}

output "ssh_clone_url" {
  description = "Базовый SSH-адрес для клонирования репозиториев"
  value       = "ssh://git@localhost:${var.ssh_port_host}"
}

output "ssh_port_host" {
  description = "Порт на хосте для SSH-доступа к GitLab"
  value       = var.ssh_port_host
}

output "image_used" {
  description = "Использованный Docker-образ"
  value       = docker_image.gitlab.name
}

output "volumes" {
  description = "Именованные тома для персистентности данных GitLab"
  value = {
    config = docker_volume.gitlab_config.name
    logs   = docker_volume.gitlab_logs.name
    data   = docker_volume.gitlab_data.name
  }
}
