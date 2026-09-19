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
  name        = "alpinelinux/gitlab:19.1.8"
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
  name  = "gitlab"
  image = docker_image.gitlab.image_id
  # Forward 80, 22 ports
  ports {
    internal = 80
    external = 8080
  }
  ports {
    internal = 22
    external = 2222
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
