terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
  }
}

# --- подключение к локальному docker ---
provider "docker" {}

# --- download GitLab CE ---
resource "docker_image" "gitlab" {
  name        = var.docker_image
  keep_localy = true
}

# --- Create naming volumes for keep data ---
resource "docker_volume" "gitlab_config" {
  name = "gitlab_config"
}

resource "docker_volume" "gitlab_logs" {
  name = "gitlab_logs"
}

resource "docker_volume" "gitlab_data" {
  name = "gitlab_data"
}

# --- running container GitLab ---
resource "docker_container" "gitlab" {
  name  = var.container_name
  image = docker_image.gitlab.image_id
  # Forward 80, 22 ports
  ports {
    internal = var.http_port_internal
    external = var.http_port_external
  }
  ports {
    internal = var.ssh_port_internal
    external = var.ssh_port_external
  }
  # Mount volumes in default places
  volumes {
    volume_name    = docker_volume.gitlab_config.name
    container_path = "/etc/gitlab"
  }
  volumes {
    volume_name    = docker_volume.gitlab_logs.name
    container_path = "/var/log/gitlab"
  }
  volumes {
    volume_name    = docker_volume.gitlab_data.name
    container_path = "/var/opt/gitlab"
  }

  # Set external URL
  # Using localhost:8080
  env = [
    "GITLAB_OMNIBUS_CONFIG=external_url 'http://localhost:8080'"
  ]

  # GitLab required extended shared memory
  shm_size = 256

  restart = "always"
}
