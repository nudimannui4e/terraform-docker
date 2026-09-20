output "connection" {
  description = "Параметры подключения к GitLab"
  value = {
    web_url       = "http://localhost/"
    ssh_port      = var.ssh_port_external
    ssh_clone_url = "ssh://git@localhost:${var.ssh_port_external}"
  }
}

output "docker" {
  description = "Параметры Docker-ресурсов GitLab"
  value = {
    container_name = docker_container.gitlab.name
    image          = docker_image.gitlab.name
    volumes = {
      config = docker_volume.gitlab_config.name
      logs   = docker_volume.gitlab_logs.name
      data   = docker_volume.gitlab_data.name
    }
  }
}
